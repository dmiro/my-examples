unit Unit1;
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    ImageList1: TImageList;
    Button1: TButton;
    Memo1: TMemo;
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Collapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


const
//ImageList.StateIndex=0 has some bugs, so we add one dummy image to position 0
cFlatUnCheck = 1;
cFlatChecked = 2;
cFlatRadioUnCheck = 3;
cFlatRadioChecked = 4;

var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure ToggleTreeViewChildrenCheckBoxes(Node:TTreeNode; cUnChecked, cChecked, cRadioUnchecked, cRadioChecked:integer);
var
  tmp:TTreeNode;
begin
   if Assigned(Node) then begin
     tmp := Node.getFirstChild;
     while Assigned(tmp) do begin
       if (Node.StateIndex in [cChecked,cUnChecked]) then
         tmp.StateIndex := Node.StateIndex;
         if tmp.HasChildren then
           ToggleTreeViewChildrenCheckBoxes(tmp, cUnChecked, cChecked, cRadioUnchecked, cRadioChecked);
       tmp := tmp.getNextSibling;
     end;
   end;
end; (*ToggleTreeViewChildrenCheckBoxes*)

procedure ToggleTreeViewParentsCheckBoxes(Node:TTreeNode; cUnChecked, cChecked, cRadioUnchecked, cRadioChecked:integer);
var
  tmp:TTreeNode;
  tmp2:TTreeNode;
  allCheck:Boolean;
begin
  tmp := Node;
  while Assigned(tmp) do begin
     if (tmp.StateIndex in [cChecked,cUnChecked]) then begin
       // if all siblings is Cheched then the parents is UnChecked else cChecked
       if not Assigned(tmp.Parent) then
         tmp2 := TTreeView(tmp.TreeView).Items.getFirstNode
       else
         tmp2 := tmp.Parent.getFirstChild;
       allCheck := true;
       while Assigned(tmp2) and allCheck do begin
         allCheck := allCheck and (tmp2.StateIndex in [cChecked]);
         tmp2 := tmp2.getNextSibling;
       end;
       // set check or uncheck
       tmp := tmp.Parent;
       if Assigned(tmp) then begin
         if allCheck then
           tmp.StateIndex := cChecked
         else
           tmp.StateIndex := cUnChecked;
       end; // if Assigned(tmp) then begin
     end;  // if (tmp.StateIndex in [cChecked,cUnChecked]) then begin
  end;   // while Assigned(tmp) do begin
end; (*ToggleTreeViewParentsCheckBoxes*)

procedure ToggleTreeViewSiblingsCheckBoxes(Node:TTreeNode; cUnChecked, cChecked, cRadioUnchecked, cRadioChecked:integer);
var
  tmp:TTreeNode;
begin
   if Assigned(Node) then begin
     tmp := Node.Parent;
     if not Assigned(tmp) then
        tmp := TTreeView(Node.TreeView).Items.getFirstNode
     else
        tmp := tmp.getFirstChild;
     while Assigned(tmp) do begin
        if (tmp.StateIndex in [cRadioUnChecked,cRadioChecked]) then
          tmp.StateIndex := cRadioUnChecked;
        tmp := tmp.getNextSibling;
     end;
   end;
end; (*ToggleTreeViewSiblingsCheckBoxes*)

procedure ToggleTreeViewCheckBoxes(Node:TTreeNode; cUnChecked, cChecked, cRadioUnchecked, cRadioChecked:integer);
var
  tmp:TTreeNode;
begin
  if Assigned(Node) then begin
    if Node.StateIndex = cUnChecked then begin
      Node.StateIndex := cChecked;
      ToggleTreeViewChildrenCheckBoxes(Node, cUnChecked, cChecked, cRadioUnchecked, cRadioChecked);
      ToggleTreeViewParentsCheckBoxes(Node, cUnChecked, cChecked, cRadioUnchecked, cRadioChecked);
    end else if Node.StateIndex = cChecked then begin
      Node.StateIndex := cUnChecked;
      ToggleTreeViewChildrenCheckBoxes(Node, cUnChecked, cChecked, cRadioUnchecked, cRadioChecked);
      ToggleTreeViewParentsCheckBoxes(Node, cUnChecked, cChecked, cRadioUnchecked, cRadioChecked);
    end else if Node.StateIndex = cRadioUnChecked then
    begin
      ToggleTreeViewSiblingsCheckBoxes(Node, cUnChecked, cChecked, cRadioUnchecked, cRadioChecked);
      Node.StateIndex := cRadioChecked;
    end; // if StateIndex = cRadioUnChecked
  end; // if Assigned(Node)
end; (*ToggleTreeViewCheckBoxes*)

procedure TForm1.TreeView1Click(Sender: TObject);
var
  P:TPoint;
begin
  GetCursorPos(P);
  P := TreeView1.ScreenToClient(P);
  if (htOnStateIcon in TreeView1.GetHitTestInfoAt(P.X,P.Y)) then
    ToggleTreeViewCheckBoxes(
       TreeView1.Selected,
       cFlatUnCheck,
       cFlatChecked,
       cFlatRadioUnCheck,
       cFlatRadioChecked);
end; (*TreeView1Click*)

procedure TForm1.TreeView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) and Assigned(TreeView1.Selected) then
    ToggleTreeViewCheckBoxes(TreeView1.Selected,cFlatUnCheck,cFlatChecked,cFlatRadioUnCheck,cFlatRadioChecked);
end; (*TreeView1KeyDown*)

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  TreeView1.FullExpand;
end; (*FormCreate*)

procedure TForm1.TreeView1Collapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  AllowCollapse := false;
end; (*TreeView1Collapsing*)

procedure TForm1.Button1Click(Sender: TObject);
var
  BoolResult:boolean;
  tn : TTreeNode;
begin
  if Assigned(TreeView1.Selected) then
  begin
    tn := TreeView1.Selected;
    BoolResult := tn.StateIndex in [cFlatChecked,cFlatRadioChecked];
    Memo1.Text := tn.Text + #13#10 + 'Selected: ' + BoolToStr(BoolResult, True);
  end;
end; (*Button1Click*)

end.
