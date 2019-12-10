/*
 * (C) Copyright 1996-2016 ECMWF.
 *
 * This software is licensed under the terms of the Apache Licence Version 2.0
 * which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
 * In applying this licence, ECMWF does not waive the privileges and immunities
 * granted to it by virtue of its status as an intergovernmental organisation
 * nor does it submit to any jurisdiction.
 */

/*! \file MarkerShadingTechnique.cc
    \brief Implementation of the Template class MarkerShadingTechnique.

    Magics Team - ECMWF 2004

    Started: Thu 26-Aug-2004

    Changes:

*/

#include "MarkerShadingTechnique.h"
#include "IsoPlot.h"
#include "LegendVisitor.h"
#include "LevelSelection.h"
#include "MatrixHandler.h"
#include "Symbol.h"
using namespace magics;

MarkerShadingTechnique::MarkerShadingTechnique() {}

MarkerShadingTechnique::~MarkerShadingTechnique() {}

Symbol *MarkerShadingTechnique::operator()(double val) {
  for (map<Interval, Symbol *>::const_iterator interval = map_.begin();
       interval != map_.end(); ++interval) {
    if (interval->first.between(val)) {
      return interval->second;
    }
  }
  return 0;
}

void MarkerShadingTechnique::operator()(const PaperPoint &point) {
  Symbol *symbol = (*this)(point.value());
  symbol->push_back(point);
}

void MarkerShadingTechnique::operator()(IsoPlot *, MatrixHandler &data,
                                        BasicGraphicsObjectContainer &out) {
  OriginalMatrixHandler original(data);
  int rows = original.rows();
  int columns = original.columns();
  const Transformation &transformation = out.transformation();

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < columns; i++) {
      Symbol *symbol = (*this)(original(j, i));
      PaperPoint pos;
      if (data.tile()) {
        pos = PaperPoint(original.column(j, i), original.row(j, i),
                         original(j, i));
      } else {
        pos = transformation(UserPoint(original.column(j, i),
                                       original.row(j, i), original(j, i)));
      }
      if (transformation.in(pos) && symbol) {
        symbol->push_back(pos);
      }
    }
  }

  for (vector<BasicGraphicsObject *>::iterator object = begin();
       object != end(); ++object)
    out.push_back(*object);
}

void MarkerShadingTechnique::visit(LegendVisitor &legend,
                                   const ColourTechnique &) {
  for (map<Interval, Symbol *>::const_iterator interval = legend_.begin();
       interval != legend_.end(); ++interval) {
    Interval range = interval->first;
    Symbol *symbol = interval->second;
    Symbol *add = new Symbol();
    add->setColour(symbol->getColour());
    add->setMarker(symbol->getMarker());
    add->setHeight(symbol->getHeight());

    legend.add(new SymbolEntry(range.min_, range.max_, add));
  }
}
CellArray *MarkerShadingTechnique::array(MatrixHandler &matrix,
                                         IntervalMap<int> &range,
                                         const Transformation &transformation,
                                         int width, int height,
                                         float resolution,
                                         const string &technique) {
  return new CellArray(matrix, range, transformation, width, height, resolution,
                       technique);
}

bool MarkerShadingTechnique::prepare(LevelSelection &levels,
                                     const ColourTechnique &technique) {
  // First let's make sure that the propertis are empty ..
  map_.clear();
  legend_.clear();
  clear();
  if (colour_.empty()) {
    technique.colours(colour_);
    if (colour_.empty())
      colour_.push_back("blue");
  }
  if (height_.empty()) {
    height_.push_back(0.2);
  }

  if (marker_.empty()) {
    marker_.push_back(18);
  }
  if (marker_.empty()) {
    marker_.push_back(18);
  }

  if (magCompare(type_, "index")) {
    symbol_.clear();
  }
  if (symbol_.empty()) {
    for (intarray::iterator marker = marker_.begin(); marker != marker_.end();
         ++marker)
      symbol_.push_back(Symbol::convert(*marker));
  }

  // Prepare the table ...
  stringarray::iterator colour = colour_.begin();
  doublearray::iterator height = height_.begin();
  stringarray::iterator name = symbol_.begin();

  for (unsigned int i = 0; i < levels.size() - 1; i++) {
    Symbol *symbol = new Symbol();
    symbol->setColour(Colour(*colour));
    symbol->setSymbol(*name);
    symbol->setHeight(*height);
    Symbol *legend = new Symbol();
    legend->setColour(Colour(*colour));
    legend->setSymbol(*name);
    legend->setHeight(*height);
    map_[Interval(levels[i], levels[i + 1])] = symbol;
    legend_[Interval(levels[i], levels[i + 1])] = legend;
    push_back(symbol);
    if (i + 1 < levels.size() - 1) {
      if (++colour == colour_.end()) {
        MagLog::warning() << "MarkerShading --> not enough colours defined!\n";
        colour = colour_.begin();
      }
      if (++height == height_.end()) {
        MagLog::warning() << "MarkerShading --> not enough heights defined!\n";
        height = height_.begin();
      }
      if (++name == symbol_.end()) {
        MagLog::warning() << "MarkerShading --> not enough markers defined!\n";
        name = symbol_.begin();
      }
    }
  }
  return false;
}

/*!
 Class information are given to the output-stream.
*/
void MarkerShadingTechnique::print(ostream &out) const {
  out << "MarkerShadingTechnique";
}
