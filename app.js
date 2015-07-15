// Let's start by requiring the library
var sandcrawler = require('sandcrawler');
var logger = require('sandcrawler-logger');
var _ = require('lodash');
var wget = require('wget');
var request = require('request');
var fs = require('fs');
var imageList = [], tilesPagesList = [], tilesList = [];
var async = require('async');
var path = require('path');

// main wikipedia file list
var filePageList = sandcrawler.spider()

  .use(logger())
  .url('https://commons.wikimedia.org/wiki/Category:Gigapixel_images_from_the_Google_Art_Project')
  .scraper(function($, done, context) {

    var data = $('ul.mw-gallery-traditional .thumb').scrape({sel: 'a', attr: 'href'});
    done(null, data);
  })
  .result(function(err, req, res) {
    imageList = _.map(res.data, function(img) { return  'https://commons.wikimedia.org'+img; });
  });

// get a file set
var getTilesPage = sandcrawler.spider()
  .use(logger())
  .scraper(function($, done){
    var data = $('#mw-imagepage-content a.image[href*="-x"]').scrape('href');
    done(null, data);
  })
  .result(function(err, req, res) {
    tilesPagesList.push(_.map(res.data, function(img) { return  'https://commons.wikimedia.org'+img; }));
  });

// get tiles url

var getTilesUrl = sandcrawler.spider()
  .use(logger())
  .scraper(function($, done){
    var data = $('.fullMedia a ').scrape('href');
    done(null, data);
  })
  .result(function(err, req, res) {
    tilesList.push(res.data);
  });

  async.series(
    [
      function(next){
        filePageList.run(function(err, remains) {
          imageList = _.flattenDeep(imageList);
          next();
        });
      },
      function(next){
        getTilesPage.url(imageList).run(function(err, remains) {
          tilesPagesList = _.flattenDeep(tilesPagesList);
          next();
        });
      },
      function(next){
        getTilesUrl.url(tilesPagesList).run(function(err, remains) {
          tilesList = _.flattenDeep(tilesList);
          next();
        });
      },
    ], function(err) {
      if (err) throw err;

      _.forEach(tilesList, function(tile, key){

        var filename =  path.basename(tile, '.jpg');
        var curentKey = key+1;
        var projectName = filename.substring(0, filename.length - 6).substring(0, 240);

        console.log(curentKey+'/'+tilesList.length, tile);
        fs.appendFileSync('./wiki/'+projectName+'.md', tile+'\n');

      })

    }
  );
