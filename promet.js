var sbMain;
var lMain;
var AvammLogin,AvammServer;

function RegisterAvammAppPage(caption,name,src) {
  sbMain.addItem({id: 'si'+name, text: caption, AppID: name, AppSrc: src, icon: ''});
  sbMain.cells('si'+name).attachURL(src, null, false);
}

function InitAvammApp(){
  window.dhx4.skin = 'material';
  sbMain =  new dhtmlXSideBar(
    { parent: document.body,
      template: 'text',
      width: '200',
      icons_path: './codebase/imgs_sidebar/',
      header: (window.innerWidth<495)|(window.innerHeight<495),
      autohide: (window.innerWidth<495)|(window.innerHeight<495),
      offsets: {
        top: 0,
        right: 0,
        bottom: 0,
        left: 0
      }
    });
  dhtmlXSideBar.prototype.templates.icontext =
  // icon 32x32
  "<img class='dhxsidebar_item_icon' src='#icons_path##icon#' border='0'>"+
  // general area for text
  "<div class='dhxsidebar_item_text'>"+
    "<div class='line_one'>#text#</div>"+ // 1st line of text
    "<div class='line_two'>#text2#</div>"+ // 2nd line of text
  "</div>";
  dhtmlXSideBar.prototype.templates.text =
  // general area for text
  "<div class='dhxsidebar_item_text'>"+
    "<a class='line' id='#AppID#' href='#AppSrc#' default>#text#</section>"+
  "</div>";
  sbMain.attachEvent("onBeforeSelect", function(id, lastId){
    //TODO:attatchURL before Load and not on Load of the page
    //console.log("onBeforeSelect",id,sbMain.cells(id));
    //sbMain.cells(id).attachURL(sbMain.cells(id).AppSrc);
		return true;
	});
  if (!AvammLogin) {
    RegisterAvammAppPage('Login','login','appbase/login.html');
    sbMain.cells('silogin').setActive();
  } else {
    sbMain.showSide();
  }

};

function StartAvammApp(){
};

function LoadData(Url,Callback) {
  if (AvammLogin) {
    dhx.ajax.timeout = 1000;
    var aTimeout = window.setTimeout(Callback,1000);
    dhx.ajax.query
      ({
        method: "GET",
        url: AvammServer+Url,
        dataType: "json",
        async: true,
        headers: {
                "Authorization": "Basic " + AvammLogin
                },
        callback: function (data){
          window.clearTimeout(aTimeout);
          if (Callback)
            Callback(data);
        }
      });
      return true;
  } else {
    return false;
  }
}

function DoLogin(aLogin,aServer,Callback) {
  console.log("Login");
  var Data;
  AvammLogin=aLogin;
  AvammServer = aServer;
  LoadData("/",function(Data){ if (Callback) Callback(Data);});
}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
