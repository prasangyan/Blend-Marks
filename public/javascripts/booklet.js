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
            var queryString = "http://localhost:3000/quickentry";
            ajaxRequest.open('POST', queryString, true);
            ajaxRequest.send('url=' + "http://google.com");
        };

request();