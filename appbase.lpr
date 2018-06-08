program appbase;
  uses js, web, classes, sysutils, webrouter, promet_base, dhtmlx_base,
    dhtmlx_form, dhtmlx_treeview, dhtmlx_layout, dhtmlx_sidebar, promet_dhtmlx;

var
  LoadEnviroment : Boolean = True;
  Treeview: TDHTMLXTreeview;
  Layout: TDHTMLXLayout;


resourcestring
  strMenu                   = 'Menü';
  strStartpage              = 'Startseite';

procedure LoadStartpage(URl : String; aRoute : TRoute; Params: TStrings);
begin
end;
procedure RouterBeforeRequest(Sender: TObject; var ARouteURL: String);
begin
  Layout.progressOn;
end;
procedure RouterAfterRequest(Sender: TObject; const ARouteURL: String);
begin
  Layout.progressOff;
end;

function FillEnviroment(aValue : JSValue) : JSValue;
var
  i: Integer;
  aCell: TDHTMLXLayoutCell;
  tmp, aId: String;
  function FillEnviromentAfterLogin(aValue: JSValue): JSValue;
  begin
    writeln('FillEnviromentAfterLogin');
    for i := 0 to Router.RouteCount-1 do
      begin
        tmp := Router.Routes[i].URLPattern;
        while pos('/',tmp)>0 do
          begin
            aId := copy(tmp,0,pos('/',tmp)-1);
            TreeView.addItem(aId,aId);
            tmp := copy(tmp,pos('/',tmp)+1,length(tmp));
          end;
      end;
    if window.document.body.clientWidth > 700 then
      Layout.cells('a').expand;
  end;
  function LoginFailed(aValueE: JSValue): JSValue;
    function DoShowError(aValue: JSValue): JSValue;
    begin
      dhtmlx.message(js.new(['type','error',
                             'text',strLoginFailed]));
      CheckLogin;
    end;
  begin
    WidgetsetLoaded._then(@DoShowError);
  end;
begin
  Layout := TDHTMLXLayout.New(js.new(['parent',window.document.body,'pattern','2U']));
  Layout.cells('a').setWidth(200);
  Layout.cells('a').setText(strMenu);
  Layout.cells('a').setCollapsedText(strMenu);
  Layout.cells('a').collapse;
  Layout.cells('b').hideHeader;
  Treeview := TDHTMLXTreeview(Layout.cells('a').attachTreeView());
  window.addEventListener('AfterLogin',@FillEnviromentAfterLogin);
  window.addEventListener('AfterLogout',@LoginFailed);
  CheckLogin;
  Router.BeforeRequest:=@RouterBeforeRequest;
  Router.AfterRequest:=@RouterAfterRequest;
end;
begin
  Router.RegisterRoute('startpage',@LoadStartpage,True).DisplayName:=strStartpage;
  if LoadEnviroment then
    WidgetsetLoaded._then(@FillEnviroment);
  if THashHistory(Router.History).getHash<>'' then
    Router.Push(THashHistory(Router.History).getHash);
end.
