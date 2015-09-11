network_scanner = angular.module('network_scanner',[
  'templates',
  'ngRoute',
  'controllers',
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
controllers.controller("RecipesController", [ '$scope', '$http',
  ($scope, $http)->

    $scope.search = (ip) ->
      console.log ("ip : " +ip.value)
      ValidateIPaddress(ip.value)

      http =
        method: "GET",
        url: "/api/search",
        params: ip_address: ip.value

      $http(http)
        .success (response) ->
          $scope.results = response

        .error (jqXHR, textStatus, errorThrown) ->
          console.log("AJAX Error: "+textStatus)
])

ValidateIPaddress = (ipaddress) ->
  if /^(192\.168\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.([0,1]?[0-9]{1,2}|2[0-4][0-9]|25[0-5]))$/.test(ipaddress)
    return true
  alert 'You have entered an invalid IP address!'
  false
