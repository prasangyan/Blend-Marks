function request() {
            var ajaxRequest;
            try {
                ajaxRequest = new XMLHttpRequest();
            }
            catch (e) {
                try {
                    ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
                    }
                    catch (e) {
                        alert("your browser breaks this functionality!"); return false;
                    }
                }
            }
            ajaxRequest.onreadystatechange = function () {
                if (ajaxRequest.readyState == 2) {
                    alert("BlendMark added");
                }
            };
            var queryString = "http://www.blendmarks.heroku.com/quickentry?url=" + window.location;
            ajaxRequest.open('GET', queryString, true);
       };
request();