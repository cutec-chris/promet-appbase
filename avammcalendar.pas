unit avammcalendar;

{$mode objfpc}{$H+}

interface

uses
  web,JS, AvammForms, dhtmlx_scheduler, Avamm, Sysutils;

type

  { TAvammCalenderForm }

  TAvammCalenderForm = class(TAvammListForm)
  private
    procedure DoLoadData; override;
  public
    constructor Create(aParent : TJSElement;aDataSet : string;aPattern : string = 'month');override;
  end;

implementation

{ TAvammCalenderForm }

procedure TAvammCalenderForm.DoLoadData;
var
  arr : TJSArray;
  aObj: TJSObject;
begin
  arr := TJSArray.new;
  DataSet.First;
  while not DataSet.EOF do
    begin
      aObj := TJSObject.new;
      aObj.Properties['id'] := DataSet.FieldByName('sql_id').AsString;
      aObj.Properties['text'] := DataSet.FieldByName('SUMMARY').AsString;
      aObj.Properties['start_date'] := FormatDateTime(ShortDateFormat+' '+ShortTimeFormat,DataSet.FieldByName('STARTDATE').AsDateTime);
      aObj.Properties['end_date'] := FormatDateTime(ShortDateFormat+' '+ShortTimeFormat,DataSet.FieldByName('ENDDATE').AsDateTime);

      arr.push(aObj);
      DataSet.Next;
    end;
  scheduler.parse(arr,'json');
end;

constructor TAvammCalenderForm.Create(aParent: TJSElement; aDataSet: string;
  aPattern: string);
  function CreateCalender(aValue: JSValue): JSValue;
  var
    aDiv: TJSHTMLElement;
  begin
    aDiv := TJSHTMLElement(document.createElement('div'));
    aDiv.style.setProperty('height','100%');
    aDiv.style.setProperty('width','100%');
    aDiv.innerHTML:='<div id="scheduler_div" class="dhx_cal_container" style="width:100%; height:100%;"><div class="dhx_cal_navline"><div class="dhx_cal_prev_button">&nbsp;</div><div class="dhx_cal_next_button">&nbsp;</div><div class="dhx_cal_today_button"></div><div class="dhx_cal_date"></div><div class="dhx_cal_tab" name="day_tab" style="right:204px;"></div><div class="dhx_cal_tab" name="week_tab" style="right:140px;"></div><div class="dhx_cal_tab" name="month_tab" style="right:76px;"></div></div><div class="dhx_cal_header"></div><div class="dhx_cal_data"></div></div>';
    Page.cells('a').attachObject(aDiv);
    if aPattern='' then
      aPattern:='month';
    scheduler.init('scheduler_div',TJSDate.New,aPattern);
  end;
begin
  inherited Create(aParent, aDataSet, '1C');
  Grid.Destroy;
  LoadScheduler;
  SchedulerLoaded._then(@CreateCalender);
end;

end.

