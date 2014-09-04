Main = function() {
  this.contentDiv = document.getElementById('content');
  this.expandedDiv = document.getElementById('expanded');
  this.expandedImg = document.getElementById('expanded-img');
  this.maxImgs = 20;
  this.collection = [];
};

Main.prototype = {
  init: function() {
    this.getJson();

    this.expandedImg.addEventListener('click', function(e) {
      page.expandedDiv.setAttribute('class', 'hidden');
    });
  },

  getJson: function() {
    var xhr = new XMLHttpRequest();
    xhr.overrideMimeType("application/json");
    xhr.open('GET', 'collection.json', true); // Replace 'my_data' with the path to your file
    xhr.onreadystatechange = function () {
      if (xhr.readyState == 4 && xhr.status == "200") {
        // Required use of an anonymous callback as .open will NOT return a value but simply returns undefined in asynchronous mode
        page.processJson(xhr.responseText);
      }
    };
    xhr.send(null);
  },

  processJson: function(response) {
    page.collection = JSON.parse(response);
    this.fillDivs();
  },

  fillDivs: function() {
    var data = null;

    for (var i = 0; i < this.collection.length; i++) {
      var data = this.collection[i];
      var div = document.createElement('div');
      var img = document.createElement('img');
      var src = '/jpg/thumb/' + data.name;

      img.setAttribute('src', src);
      div.setAttribute('data-index', i);
      div.setAttribute('class', 'img');
      div.appendChild(img);
      div.addEventListener('click', function(e) {
        page.expandIt(page.collection[this.getAttribute('data-index')]);
      });

      this.contentDiv.appendChild(div);
    }
  },

  expandIt: function(data) {
    var src = '/jpg/' + data.name;
    page.expandedDiv.setAttribute('class', 'shown');
    page.expandedImg.setAttribute('src', src);
  }
};