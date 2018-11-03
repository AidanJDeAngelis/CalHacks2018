/*
Thank you to brozeph for the craigslist search driver
project: https://github.com/brozeph/node-craigslist
*/

var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var craigslist = require('node-craigslist')

var app = express();


//Custom additions
var server = app.listen(3000);
app.get('/', function(req, res) {res.render('index')});

//Following must be set by app request

app.get('/list', function(req, res) {
  var numItems = 50;
  var options = {};
  if ('city' in req.query) {
      options['city'] = req.query.city;
  }
  if ('baseHost' in req.query) {
      options['baseHost'] = req.query.baseHost;
  }
  if ('maxPrice' in req.query) {
      options['maxPrice'] = req.query.maxPrice;
  }
  if ('minPrice' in req.query) {
      options['minPrice'] = req.query.minPrice;
  }
  if ('category' in req.query) {
      options['category'] = req.query.category;
  }
  if ('offset' in req.query) {
      options['offset'] = req.query.offset;
  }
  if ('numItems' in req.query) {
      numItems = req.query.numItems;
  }
  var
    craigslist = require('node-craigslist'),
    client = new craigslist.Client(options);
  res.setHeader("Content-Type", "application/json");
  res.write("[")
  client
    .list()
    .then(function(listings) {
      // play with listings here...
      for (var i = 0; i < listings.length && i < numItems; i+=1) {
          listing = listings[i];
          delete listing["pid"];
          if (listing['hasPic']) {
              res.write(JSON.stringify(listing));
          }
          if (i < listings.length - 1 && i < numItems - 1) {
              res.write(",");
          }
      }
    })
    .then(function() {res.write("]"); res.end()})
    .catch((err) => {
      console.error(err);
    });

});
app.get('/search', function(req, res) {
  var numItems = 50;
  options = {};
  if (!("query" in req.query)) {
      throw "No search query!"
  }
  var searchQuery = req.query.query;
  if ('city' in req.query) {
      options['city'] = req.query.city;
  }
  if ('baseHost' in req.query) {
      options['baseHost'] = req.query.baseHost;
  }
  if ('maxPrice' in req.query) {
      options['maxPrice'] = req.query.maxPrice;
  }
  if ('minPrice' in req.query) {
      options['minPrice'] = req.query.minPrice;
  }
  if ('category' in req.query) {
      options['category'] = req.query.category;
  }
  if ('postCode' in req.query) {
      options['postal'] = req.query.postCode;
      if ('distance' in req.query) {
          options['distance'] = req.query.distance;
      }
  }
  if ('offset' in req.query) {
      options['offset'] = req.query.offset;
  }
  if ('numItems' in req.query) {
      numItems = req.query.numItems;
  }
  var client = new craigslist.Client(options);

  res.setHeader("Content-Type", "application/json");
  res.write("[")
  client
    .search(options, searchQuery)
    .then(function(listings) {
      // play with listings here...
      for (var i = 0; i < listings.length && i < numItems; i+=1) {
          listing = listings[i];
          delete listing["pid"];
          if (listing['hasPic']) {
              res.write(JSON.stringify(listing));
          }
          if (i < listings.length - 1 && i < numItems - 1) {
              res.write(",");
          }
      }
    })
    .then(function() {res.write("]"); res.end()})
    .catch((err) => {
      console.error(err);
    });

});
//End additions

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
