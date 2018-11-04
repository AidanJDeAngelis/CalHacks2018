/*
Thank you to brozeph for the craigslist search driver
project: https://github.com/brozeph/node-craigslist
*/

var express = require('express');

var craigslist = require('node-craigslist'),
client = new craigslist.Client();

var app = express();


//Custom additions
var server = app.listen(3069);
var request = require('request');

//Following must be set by app request

app.get('/craigslist/list', function(req, res) {
  var numItems = 50;
  var options = {'city':'sfbay'};
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
  res.setHeader("Content-Type", "application/json");
  res.write("[")
  client
    .list(options)
    .then(function(listings) {
        // play with listings here...


        listings_ = [];
        if (numItems < listings.length) {
          listings.splice(numItems);
        }
        return Promise.all(listings.map(function(listing) {
          return new Promise(function(resolve, reject) {
            delete listing["pid"];
            if (listing['hasPic']) {
                request.get(listing['url'], function (error, response, body) {
                    if (!error && response.statusCode == 200) {
                        var m;
                        var urls = [];
                        var rex = /<img.*?src="([^">]*\/([^">]*?))".*?>/g;

                        while ( m = rex.exec( body ) ) {
                            urls.push( m[1] );
                        }
                        listing['images'] = urls;
                        resolve(listing);
                    }
                });
          }
        });
        }));
    })
    .then(function(listings_) {
        for (var i = 0; i < listings_.length && i < numItems; i+=1) {
            listing = listings_[i];
            if (listing['hasPic']) {
                res.write(JSON.stringify(listing));
                if (i < listings_.length - 1 && i < numItems - 1) {
                    res.write(",");
                } else {
                  res.write("]");
                  res.end();
                }
            }
        }
    })
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


app.use(express.json());
app.use(express.urlencoded({ extended: false }));


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

console.log("listening on port 3069");

module.exports = app;
