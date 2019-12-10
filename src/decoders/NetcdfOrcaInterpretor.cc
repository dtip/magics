/*
 * (C) Copyright 1996-2016 ECMWF.
 *
 * This software is licensed under the terms of the Apache Licence Version 2.0
 * which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
 * In applying this licence, ECMWF does not waive the privileges and immunities
 * granted to it by virtue of its status as an intergovernmental organisation
 * nor does it submit to any jurisdiction.
 */

/*! \file NetcdfOrcaInterpretor.h
    \brief Implementation of the Template class NetcdfOrcaInterpretor.

    Magics Team - ECMWF 2004

    Started: Tue 17-Feb-2004

    Changes:

*/

#include "NetcdfOrcaInterpretor.h"
#include "Factory.h"
#include "NetcdfData.h"
#include <limits>

using namespace magics;

NetcdfOrcaInterpretor::NetcdfOrcaInterpretor() {}

NetcdfOrcaInterpretor::~NetcdfOrcaInterpretor() {}

bool NetcdfOrcaInterpretor::interpretAsMatrix(Matrix **data) {
  if (*data)
    return false;

  Netcdf netcdf(path_, dimension_method_);
  NetVariable var = netcdf.getVariable(longitude_);
  vector<size_t> dims;
  var.getDimensions(dims);

  int jm = dims[dims.size() - 2];
  int im = dims[dims.size() - 1];

  Matrix *matrix = new Matrix(jm, im);

  *data = matrix;

  double missing = netcdf.getMissing(field_, missing_attribute_);
  typedef pair<int, int> point_type;

  vector<std::pair<point_type, pair<int, int>>> points;

  matrix->missing(missing);
  // get the data ...
  try {
    Timer time("orca", "decode");
    map<string, string> first, last;
    setDimensions(dimension_, first, last);

    MagLog::debug() << "data[" << matrix->size() << ":"
                    << *std::min_element(matrix->begin(), matrix->end()) << ", "
                    << offset_ << "\n";

    vector<double> latm;
    vector<double> lonm;
    vector<double> data;

    netcdf.get(longitude_, lonm, first, last);
    netcdf.get(latitude_, latm, first, last);
    netcdf.get(field_, data, first, last);

    double minlat = *std::min_element(latm.begin(), latm.end());
    double maxlat = *std::max_element(latm.begin(), latm.end());

    double minlon = *std::min_element(lonm.begin(), lonm.end());
    double maxlon = *std::max_element(lonm.begin(), lonm.end());

    vector<double> &lon = matrix->columnsAxis();
    vector<double> &lat = matrix->rowsAxis();

    // for the lon we take the fisrt line :
    double inci = (maxlon - minlon) / ((im)-1);
    double incj = (maxlat - minlat) / ((jm)-1);
    for (int i = 0; i < im; i++)
      lon.push_back(minlon + (i * inci));
    // for the lon we take the fisrt column :
    for (int i = 0; i < jm; i++)
      lat.push_back(minlat + (i * incj));

    typedef map<double, map<double, pair<int, int>>> Helper;

    // typedef map<double, double> Helper;
    Helper helper;
    int row = 0;
    for (vector<double>::iterator y = lat.begin(); y != lat.end(); ++y) {
      helper.insert(make_pair(*y, map<double, pair<int, int>>()));

      Helper::iterator h = helper.find(*y);

      int column = 0;
      for (vector<double>::iterator x = lon.begin(); x != lon.end(); ++x) {
        h->second.insert(make_pair(*x, std::make_pair(row, column)));

        matrix->push_back(missing);
        column++;
      }
      row++;
    }

    int r = 0;
    int c = 0;

    double lat11, lat12, lat21, lat22;
    double lon11, lon12, lon21, lon22;
    double val11, val12, val21, val22;

    for (int r = 0; r < jm - 1; r++) {
      for (int c = 0; c < im - 1; c++) {
        lat11 = latm[c + (im * r)];

        lat12 = latm[(c + 1) + (im * r)];
        minlat = std::min(lat11, lat12);
        maxlat = std::max(lat11, lat12);
        lat21 = latm[c + (im * (r + 1))];
        minlat = std::min(minlat, lat21);
        maxlat = std::max(maxlat, lat21);
        lat22 = latm[(c + 1) + (im * (r + 1))];
        minlat = std::min(minlat, lat22);
        maxlat = std::max(maxlat, lat22);

        lon11 = lonm[c + (im * r)];
        lon12 = lonm[(c + 1) + (im * r)];
        if (lon12 < lon11)
          lon12 += 360.;
        minlon = std::min(lon11, lon12);
        maxlon = std::max(lon11, lon12);
        lon21 = lonm[c + (im * (r + 1))];
        minlon = std::min(minlon, lon21);
        maxlon = std::max(maxlon, lon21);
        lon22 = lonm[(c + 1) + (im * (r + 1))];
        if (lon22 < lon21)
          lon22 += 360.;
        minlon = std::min(minlon, lon22);
        maxlon = std::max(maxlon, lon22);

        val11 = data[c + (im * r)];
        val12 = data[(c + 1) + (im * r)];
        val21 = data[c + (im * (r + 1))];
        val22 = data[(c + 1) + (im * (r + 1))];

        // find the points from the helper!
        Helper::iterator low, up;
        low = helper.lower_bound(minlat);
        up = helper.lower_bound(maxlat);
        if (low == helper.end() || up == helper.end())
          break;
        for (Helper::iterator it = low; it != up; ++it) {
          if (it == helper.end())
            break;
          map<double, pair<int, int>> &lons = it->second;
          map<double, pair<int, int>>::iterator llow = lons.lower_bound(minlon);
          map<double, pair<int, int>>::iterator lup = lons.lower_bound(maxlon);
          if (llow == lons.end() || lup == lons.end())
            break;
          ;
          for (map<double, pair<int, int>>::iterator lit = llow; lit != lup;
               ++lit) {
            double lat = it->first;
            double lon = lit->first;
            std::pair<int, int> index = lit->second;

            // we interpolate at the point using the 4 points found!
            double val = missing;
            if (val11 != missing && val12 != missing && val21 != missing &&
                val22 != missing) {
              double val1 = ((lon12 - lon) / (lon12 - lon11)) * val11 +
                            ((lon - lon11) / (lon12 - lon11)) * val12;

              double val2 = ((lon22 - lon) / (lon22 - lon21)) * val21 +
                            ((lon - lon21) / (lon22 - lon21)) * val22;
              if (std::isnan(val1)) {
                if (std::isnan(val2)) {
                  val = missing;
                } else
                  val = ((lat - lat11) / (lat22 - lat11)) * val2;
              } else {
                if (std::isnan(val2)) {
                  val = ((lat22 - lat) / (lat22 - lat11)) * val1;
                } else {
                  val = ((lat22 - lat) / (lat22 - lat11)) * val1 +
                        ((lat - lat11) / (lat22 - lat11)) * val2;
                }
              }

              if (std::isnan(val) || std::isinf(val) || std::isinf(-val)) {
                val = missing;
              }
            }
            if (std::isnan(val))
              val = missing;
            if ((*matrix)[index.second + (index.first * im)] == missing)
              (*matrix)[index.second + (index.first * im)] = val;
          }
          matrix->multiply(scaling_);
          matrix->plus(offset_);
        }
      }
    }

    matrix->multiply(scaling_);
    matrix->plus(offset_);
    matrix->setMapsAxis();

    MagLog::dev() << *matrix << "\n";
  }

  catch (MagicsException &e) {
    MagLog::error() << e << "\n";
    return false;
  }
  return true;
}

bool NetcdfOrcaInterpretor::interpretAsPoints(PointsList &points) {
  // later!

  // get the data ...
  try {
    MagLog::dev() << " Netcdf File Path --->" << path_ << "\n";
    Netcdf netcdf(path_, dimension_method_);
    map<string, string> first, last;
    setDimensions(dimension_, first, last);
    double missing = netcdf.getMissing(field_, missing_attribute_);
    vector<double> latm;
    vector<double> lonm;
    vector<double> data;

    netcdf.get(longitude_, lonm, first, last);
    netcdf.get(latitude_, latm, first, last);
    netcdf.get(field_, data, first, last);

    vector<double>::iterator lat = latm.begin();
    vector<double>::iterator lon = lonm.begin();
    vector<double>::iterator val = data.begin();

    while (lat != latm.end()) {
      double value = *val;
      if (std::isnan(value))
        value = missing;

      if (value != missing) {
        value = (value * scaling_) + offset_;
        points.push_back(new UserPoint(*lon, *lat, value));
      }
      ++lat;
      ++lon;
      ++val;
    }
  }

  catch (MagicsException &e) {
    MagLog::error() << e << "\n";
  }
  return true;
}

void NetcdfOrcaInterpretor::customisedPoints(
    const Transformation &transformation, const std::set<string> &,
    CustomisedPointsList &out, int thinning) {
  try {
    MagLog::dev() << " Netcdf File Path --->" << path_ << "\n";
    Netcdf netcdf(path_, dimension_method_);
    map<string, string> first, last;
    setDimensions(dimension_, first, last);
    double missing = netcdf.getMissing(field_, missing_attribute_);
    vector<double> latitudes;
    vector<double> longitudes;
    vector<double> x_component, y_component;

    netcdf.get(longitude_, longitudes, first, last);
    netcdf.get(latitude_, latitudes, first, last);
    netcdf.get(x_component_, x_component, first, last);
    netcdf.get(y_component_, y_component, first, last);

    for (int ind = 0; ind < latitudes.size(); ind += thinning) {
      CustomisedPoint *point = new CustomisedPoint();
      point->longitude(longitudes[ind]);
      point->latitude(latitudes[ind]);
      (*point)["x_component"] = x_component[ind];
      (*point)["y_component"] = y_component[ind];
      out.push_back(point);
    }
  }

  catch (MagicsException &e) {
    MagLog::error() << e << "\n";
  }
}

/*!
 Class information are given to the output-stream.
*/
void NetcdfOrcaInterpretor::print(ostream &out) const {
  out << "NetcdfOrcaInterpretor[";
  NetcdfInterpretor::print(out);

  out << "]";
}

NetcdfInterpretor *NetcdfOrcaInterpretor::guess(const NetcdfInterpretor &from) {
  if (from.field_.empty() &&
      (from.x_component_.empty() || from.y_component_.empty()))
    return 0;

  Netcdf netcdf(from.path_, from.dimension_method_);

  string variable = from.field_;

  // get the attribute coordinates

  string coordinates =
      netcdf.getVariable(variable).getAttribute("coordinates", string(""));
  string latlon("lat lon");
  coordinates = coordinates.substr(0, latlon.size());
  if (coordinates == "lat lon") {
    NetcdfOrcaInterpretor *interpretor = new NetcdfOrcaInterpretor();

    interpretor->NetcdfInterpretor::copy(from);
    interpretor->latitude_ = "lat";
    interpretor->longitude_ = "lon";
    interpretor->time_variable_ = netcdf.detect(variable, "time");
    interpretor->level_variable_ = netcdf.detect(variable, "level");
    interpretor->number_variable_ = netcdf.detect(variable, "number");
    return interpretor;
  }
  return 0;
}

static SimpleObjectMaker<NetcdfOrcaInterpretor, NetcdfInterpretor>
    netcdf_geovalues_interpretor("orca");
