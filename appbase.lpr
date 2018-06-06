program appbase;
  uses js,web,classes,sysutils,webrouter,
    promet_base, dhtmlx_base, dhtmlx_form, dhtmlx_treeview, dhtmlx_layout, dhtmlx_sidebar;

var
  LoadEnviroment : Boolean = True;
  Treeview: TDHTMLXTreeview;
  Layout: TDHTMLXLayout;


procedure ShowStartpage(URl : String; aRoute : TRoute; Params: TStrings);
begin

end;

function FillEnviroment(aValue : JSValue) : JSValue;
var
  i: Integer;
  aCell: TDHTMLXLayoutCell;
begin
  Layout := TDHTMLXLayout.New(js.new(['parent',window.document.body,'pattern','2U']));
  Treeview := TDHTMLXTreeview(Layout.cells('a').attachTreeView());
  for i := 0 to Router.RouteCount-1 do
    begin
      TreeView.addItem(Router.Routes[i].ID,Router.Routes[i].DisplayName);
    end;
end;
begin
  Router.RegisterRoute('startpage',@ShowStartpage,True).DisplayName:='Startseite';
  if LoadEnviroment then
    begin
      WidgetsetLoaded._then(@FillEnviroment);
    end;
  if THashHistory(Router.History).getHash<>'' then
    Router.Push(THashHistory(Router.History).getHash);
end.