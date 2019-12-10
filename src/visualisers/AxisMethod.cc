/*
 * (C) Copyright 1996-2016 ECMWF.
 *
 * This software is licensed under the terms of the Apache Licence Version 2.0
 * which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
 * In applying this licence, ECMWF does not waive the privileges and immunities
 * granted to it by virtue of its status as an intergovernmental organisation
 * nor does it submit to any jurisdiction.
 */

/*! \file AxisMethod.cc
    \brief Implementation of the Template class AxisMethod.

    Magics Team - ECMWF 2005

    Started: Fri 7-Oct-2005

    Changes:

*/

#include <limits>

#include "Axis.h"
#include "AxisMethod.h"
#include "Transformation.h"
#include <list>

using namespace magics;

AxisMethod::AxisMethod() {}

AxisMethod::~AxisMethod() {}

/*!
 Class information are given to the output-stream.
*/
void AxisMethod::print(ostream &out) const {
  out << "AxisMethod[";
  out << "]";
}

void LogarithmicAxisMethod::prepare(const Axis &axis, AxisItems &items) {
  vector<int> factor;
  factor.push_back(1);
  factor.push_back(2);
  factor.push_back(5);

  double min = axis.min();
  double max = axis.max();

  int s1 = (min < 0) ? -1 : 1;
  int s2 = (max < 0) ? -1 : 1;

  int log1 = s1 * ((min) ? log10(s1 * min) : -5);
  int log2 = s2 * ((max) ? log10(s2 * max) : -5);

  bool reduce = (min * max) < 0;

  std::set<double> ticks;

  double from = std::min(min, max);
  double to = std::max(min, max);

  for (int i = std::min(log1, log2); i <= std::max(log1, log2); i += 1) {
    for (vector<int>::iterator f = factor.begin(); f != factor.end(); ++f) {
      double x;
      if (!reduce || (reduce && i > -4)) {
        x = (*f) * pow(10., i);
        if (from <= x && x <= to && x != 0)
          ticks.insert(x);
        x = -x;
        if (from <= x && x <= to && x != 0)
          ticks.insert(x);
      }
      if (!reduce || (reduce && -i > -4)) {
        x = (*f) * pow(10., -i);
        if (from <= x && x <= to && x != 0)
          ticks.insert(x);
        x = -x;
        if (from <= x && x <= to && x != 0)
          ticks.insert(x);
      }
    }
  }

  for (std::set<double>::const_iterator step = ticks.begin();
       step != ticks.end(); ++step) {
    items.push_back(new AxisItem(*step, axis.label_format_));
  }
}

void HyperAxisMethod::updateX(const Transformation &transformation) {
  hyperMin_ = transformation.getDataVectorMinX();
  hyperMax_ = transformation.getDataVectorMaxX();
}

void HyperAxisMethod::updateY(const Transformation &transformation) {
  hyperMin_ = transformation.getDataVectorMinY();
  hyperMax_ = transformation.getDataVectorMaxY();
}

void HyperAxisMethod::prepare(const Axis &axis, AxisItems &items) {
  double inc;
  int nb = 7;
  double step;
  double log, ws;
  bool horizontal = false;

  double min = hyperMin_.front();
  double max = hyperMax_.front();
  double wmax = std::max(hyperMin_.front(), hyperMax_.front());
  double wmin = std::min(hyperMin_.front(), hyperMax_.front());
  if (wmin == wmax) {
    wmax = std::max(hyperMin_.back(), hyperMax_.back());
    wmin = std::min(hyperMin_.back(), hyperMax_.back());
    min = hyperMin_.back();
    max = hyperMax_.back();
    horizontal = true;
  }

  if (axis.interval_ == INT_MAX) {
    while (nb < 10) {
      step = (wmax - wmin) / nb;
      log = log10(step);
      ws = pow(10., int(log));
      inc = ceil(step / ws) * ws;
      MagLog::dev() << "Automatic method ---> increment = " << inc
                    << " ---> try base=" << inc / ws << endl;

      if (wmax - wmin / inc > 5 &&
          (inc / ws == 1 || inc / ws == 2 || inc / ws == 3 || inc / ws == 5 ||
           inc / ws == 10)) {
        MagLog::dev() << "Automatic method ---> increment " << inc << " OK! "
                      << endl;
        break;
      }
      nb++;
    }
  }

  else {
    inc = axis.interval_;
  }
  std::set<double> list;

  if (min < max) {
    double first = floor(min / inc) * inc;
    double last = 0.;
    int i = 0;
    for (double val = first; val <= max; val = first + (inc * i)) {
      if (val >= min && val <= max) {
        list.insert(value(val));
        last = val;
      }
      i++;
    }
    list.insert(value(last + inc));
  } else {
    double first = floor(min / inc) * inc;
    double last = 0.;
    int i = 0;
    for (double val = first; val >= max; val = first - (inc * i)) {
      if (val >= wmin && val <= wmax) {
        list.insert(value(val));
        last = val;
      }
      i++;
    }
    list.insert(value(last - inc));
  }

  double imin = hyperMin_[0];
  double imax = hyperMax_[0];
  double jmin = hyperMin_[1];
  double jmax = hyperMax_[1];
  ;
  double iw = imax - imin;
  double jw = jmax - jmin;

  for (std::set<double>::iterator i = list.begin(); i != list.end(); ++i) {
    vector<double> val;
    if (horizontal) {
      val.push_back(imin);

      val.push_back(*i);
      items.push_back(new AxisHyperItem(*i, val));
    } else {
      val.push_back(*i);
      double j = jmin + ((*i) - imin) * (jw / iw);
      val.push_back(j);
      items.push_back(new AxisHyperItem(*i, val));
    }
  }
}

void AxisMethod::prepare(list<double> &out, double from, double to, double by,
                         double ref) {
  out.clear();
  int i = 0;
  double val = ref + (i * by);

  while (val < to) {
    if (val > from)
      out.push_back(value(val));
    i++;
    val = ref + (i * by);
  }
  i = 1;
  val = ref - (i * by);
  while (val > from) {
    if (val < to)
      out.push_back(value(val));
    i++;
    val = ref - (i * by);
  }

  out.sort();

  if (from > to)
    out.reverse();
}

void AxisMethod::prepare(const Axis &axis, AxisItems &items) {
  double inc;
  int nb = 7;
  double step;
  double log, ws;

  double ref = axis.grid_reference_level_;

  double min = axis.min();
  double max = axis.max();

  double wmax = std::max(min, max);
  double wmin = std::min(min, max);

  bool automatic = false;

  if (axis.interval_ == INT_MAX) {
    automatic = true;
    while (nb < 20) {
      step = (wmax - wmin) / nb;
      log = log10(step);
      ws = pow(10., int(log));
      inc = ceil(step / ws) * ws;
      MagLog::debug() << "Automatic method ---> increment = " << inc
                      << " ---> try base=" << inc / ws << endl;
      MagLog::dev() << "nb " << nb << "  " << wmax - wmin / inc << "-->"
                    << inc / ws << endl;
      if (wmax - wmin / inc > 5 &&
          (inc / ws == 1 || inc / ws == 2 || inc / ws == 3 || inc / ws == 5 ||
           inc / ws == 10)) {
        MagLog::debug() << "Automatic method ---> increment " << inc << " OK! "
                        << endl;
        break;
      }
      nb++;
    }
  }

  else {
    inc = axis.interval_;
  }

  list<double> slist;

  wmax += inc;
  wmin -= inc;

  if (ref == INT_MAX) {
    ref = floor(min / inc) * inc;
  }

  prepare(slist, wmin, wmax, inc, ref);

  if (axis.interval_ == INT_MAX) {
    while (slist.size() > 10) {
      inc *= 2;
      prepare(slist, wmin, wmax, inc, ref);
    }
  }

  std::list<double> shortlist;
  int mod = (slist.size() / 12);
  mod++;
  int i = 0;
  for (std::list<double>::iterator e = slist.begin(); e != slist.end(); ++e) {
    if (!automatic)
      shortlist.push_back(*e);
    else if (i % mod == 0)
      shortlist.push_back(*e);
    i++;
  }

  // First we add the minor tich before the first one...
  std::list<double>::iterator front = shortlist.begin();
  double first = *front - inc;
  step = inc / (axis.minor_tick_count_ + 1);
  for (double ii = first; ii < *front; ii += step) {
    items.push_back(new AxisMinorTickItem(ii));
  }

  double last = std::numeric_limits<double>::max();
  for (std::list<double>::iterator i = front; i != shortlist.end(); ++i) {
    // Add the minor Axis Items!!!
    if (last != std::numeric_limits<double>::max()) {
      double step = (*i - last) / (axis.minor_tick_count_ + 1);
      for (double ii = last + step; ii < *i; ii += step) {
        items.push_back(new AxisMinorTickItem(ii));
      }
    }
    last = *i;

    addItem(items, *i, axis.label_format_);
  }
}

void AxisMethod::updateX(const Transformation &transformation) {
  min_ = transformation.getMinX();
  max_ = transformation.getMaxX();
}

void AxisMethod::updateY(const Transformation &transformation) {
  min_ = transformation.getMinY();
  max_ = transformation.getMaxY();
}

void PositionListAxisMethod::prepare(const Axis &axis, AxisItems &items) {
  for (vector<double>::const_iterator tick = axis.positions_.begin();
       tick != axis.positions_.end(); ++tick) {
    items.push_back(new AxisItem(*tick, axis.label_format_));
  }
}
