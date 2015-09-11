network_scanner = angular.module('network_scanner',[
  'templates',
  'ngRoute',
  'controllers',
  'ngProgress'
])

network_scanner.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      )
])

controllers = angular.module('controllers',[])
controllers.controller("RecipesController", [ '$scope', '$http', 'ngProgressFactory'
  ($scope, $http, ngProgressFactory)->


    $scope.search = (ip) ->

      $scope.progressbar = ngProgressFactory.createInstance()
      $scope.progressbar.start()

      console.log ("ip : " +ip.value)
      ValidateIPaddress(ip.value)

      http =
        method: "GET",
        url: "/api/search",
        params: ip_address: ip.value

      $http(http)
        .success (response) ->
          $scope.results = response
          $scope.progressbar.complete()

        .error (jqXHR, textStatus, errorThrown) ->
          console.log("AJAX Error: "+textStatus)
])

ValidateIPaddress = (ipaddress) ->
  if /^(192\.168\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$/.test(ipaddress)
    return true
  alert 'You have entered an invalid IP address!'
  false
