
function Telligent_PopupMenu(varName,groupCssClass,itemCssClass,itemSelectedCssClass,itemExpandedCssClass,expandImageUrl,expandImageWidth,expandImageHeight,iconWidth,iconHeight,position,zIndex,onMenuOpenFunction,onMenuCloseFunction,onMenuItemOverFunction,menuItems,closeOnMouseOut)
{this._variableName=varName;this.GroupCssClass=groupCssClass;this.ItemCssClass=itemCssClass;this.ItemSelectedCssClass=itemSelectedCssClass;this.ItemExpandedCssClass=itemExpandedCssClass;this._menuItems=new Array();this.Position=position;this.ZIndex=zIndex;this._menuLevels=new Array();this._initialized=false;this._currentLevel=-1;this._isOpen=false;this.ExpandImageUrl=expandImageUrl;this.ExpandImageWidth=expandImageWidth;this.ExpandImageHeight=expandImageHeight;this.IconWidth=iconWidth;this.IconHeight=iconHeight;this.OnMenuOpenFunction=onMenuOpenFunction;this.OnMenuCloseFunction=onMenuCloseFunction;this.OnMenuItemOverFunction=onMenuItemOverFunction;this._originalDocumentOnClick=null;this._cancelClick=false;this._closeOnMouseOut=closeOnMouseOut;this._openingElement=null;this._openingElementOnMouseOverFunction=null;this._openingElementOnMouseOutFunction=null;this._closeTimeout=null;if(document.onclick)
this._originalDocumentOnClick=document.onclick;document.onclick=new Function(this._variableName+'._documentOnClick();');this.ParseMenuItems(menuItems,null);Telligent_Common.RegisterDisposableControl(this._variableName);}
Telligent_PopupMenu.prototype.IsOpen=function()
{return this._isOpen;}
Telligent_PopupMenu.prototype.Dispose=function()
{if(this._initialized)
{for(var i=0;i<this._menuLevels.length;i++)
{this._disposeLevel(this._menuLevels[i]);if(this._menuLevels[i]._popupPanel)
this._menuLevels[i]._popupPanel.Dispose();}
if(this._openingElement)
{if(this._openingElementOnMouseOverFunction)
this._openingElement.onmouseover=this._openingElementOnMouseOverFunction;if(this._openingElementOnMouseOutFunction)
this._openingElement.onmouseout=this._openingElementOnMouseOutFunction;this._openingElementOnMouseOverFunction=null;this._openingElementOnMouseOutFunction=null;this._openingElement=null;}
this._initialized=false;}}
Telligent_PopupMenu.prototype._disposeLevel=function(menuLevel)
{if(menuLevel&&menuLevel._popupPanel)
{var nodes=menuLevel._popupPanel.GetPanelNodes();if(nodes[0]&&nodes[0].childNodes[0])
{var tbody=nodes[0].childNodes[0];for(var j=0;j<tbody.childNodes.length;j++)
{if(tbody.childNodes[j].childNodes[0]&&tbody.childNodes[j].childNodes[0]._menuItem)
{tbody.childNodes[j].childNodes[0]._menuItem._element=null;tbody.childNodes[j].childNodes[0]._menuItem=null;tbody.childNodes[j].childNodes[0].onmouseover=null;tbody.childNodes[j].childNodes[0].onclick=null;}}}}}
Telligent_PopupMenu.prototype.Open=function(x,y,positionWidth,positionHeight)
{if(!this._initialized)
this._initialize();this._menuLevels[0]._popupPanel.Show(x,y,positionWidth,positionHeight);this._currentLevel=0;this._isOpen=true;this._openingElement=null;if(this.OnMenuOpenFunction)
this.OnMenuOpenFunction(this);}
Telligent_PopupMenu.prototype.OpenAtElement=function(element)
{if(!this._initialized)
this._initialize();this._menuLevels[0]._popupPanel.ShowAtElement(element);this._currentLevel=0;this._isOpen=true;this._openingElement=element;this._openingElementOnMouseOverFunction=element.onmouseover;this._openingElementOnMouseOutFunction=element.onmouseout;element.onmouseover=new Function(this._variableName+'._mouseOver();');element.onmouseout=new Function(this._variableName+'._mouseOut();');if(this.OnMenuOpenFunction)
this.OnMenuOpenFunction(this);}
Telligent_PopupMenu.prototype._mouseOut=function()
{if(this._closeOnMouseOut)
{window.clearTimeout(this._closeTimeout);this._closeTimeout=window.setTimeout(new Function(this._variableName+'.Close();'),249);}}
Telligent_PopupMenu.prototype._mouseOver=function()
{if(this._closeOnMouseOut)
window.clearTimeout(this._closeTimeout);}
Telligent_PopupMenu.prototype.Close=function(level)
{if(!level)
level=0;if(level==0&&this._openingElement)
{if(this._openingElementOnMouseOverFunction)
this._openingElement.onmouseover=this._openingElementOnMouseOverFunction;if(this._openingElementOnMouseOutFunction)
this._openingElement.onmouseout=this._openingElementOnMouseOutFunction;this._openingElementOnMouseOverFunction=null;this._openingElementOnMouseOutFunction=null;this._openingElement=null;}
for(var i=this._menuLevels.length-1;i>=level;i--)
{if(this._menuLevels[i])
{if(this._menuLevels[i].CurrentMenuItem)
{this._menuLevels[i].CurrentMenuItem._element.className=this.ItemCssClass;this._menuLevels[i].CurrentMenuItem=null;}
this._menuLevels[i]._popupPanel.Hide();}}
this._currentLevel=level-1;if(this._currentLevel<=-1)
{this._isOpen=false;if(this.OnMenuCloseFunction)
this.OnMenuCloseFunction(this);}}
Telligent_PopupMenu.prototype._itemClick=function(menuItem,level)
{this._cancelClick=true;if(menuItem.ClientScript||menuItem.NavigateUrl)
this.Close();if(menuItem.ClientScript)
{menuItem.ClientScript(menuItem);}
if(menuItem.NavigateUrl)
{if(!menuItem.NavigateTarget)
window.location=menuItem.NavigateUrl;else
window.open(menuItem.NavigateUrl,menuItem.NavigateTarget);}
return false;}
Telligent_PopupMenu.prototype._itemMouseOver=function(menuItem,level,ignoreHideAndAnimation)
{if(this._menuLevels.length<=level||(this._currentLevel==level&&this._menuLevels[level].CurrentMenuItem==menuItem&&!ignoreHideAndAnimation))
return;if(this._menuLevels[level].CurrentMenuItem!=menuItem)
{if(!ignoreHideAndAnimation)
{this.Close(level+1);}
if(this._menuLevels[level].CurrentMenuItem&&this._menuLevels[level].CurrentMenuItem!=menuItem)
this._menuLevels[level].CurrentMenuItem._element.className=this.ItemCssClass;if(level>0&&this._menuLevels[level-1].CurrentMenuItem)
this._menuLevels[level-1].CurrentMenuItem._element.className=this.ItemExpandedCssClass;menuItem._element.className=this.ItemSelectedCssClass;this._menuLevels[level].CurrentMenuItem=menuItem;if(menuItem._menuItems!=null&&menuItem._menuItems.length>0)
{if(this._menuLevels.length==level+1)
this._menuLevels[level+1]=new Telligent_PopupMenuLevel(level+1,menuItem,new Telligent_PopupPanel(this._variableName+'._menuLevels['+(level+1)+']._popupPanel',this.GroupCssClass,'leftright',this.ZIndex,null,new Function('window.'+this._variableName+'.Close('+(level+1)+');'),false,'',new Function('window.'+this._variableName+'._mouseOver();'),new Function('window.'+this._variableName+'._mouseOut();')),this);else
this._menuLevels[level+1].MenuItem=menuItem;this._populatePopupPanel(this._menuLevels[level+1],menuItem._menuItems);this._menuLevels[level+1]._popupPanel.ShowAtElement(menuItem._element,ignoreHideAndAnimation);this._currentLevel=level+1;}
if(!ignoreHideAndAnimation&&this.OnMenuItemOverFunction)
this.OnMenuItemOverFunction(menuItem);}
else
{if(!ignoreHideAndAnimation)
{this.Close(level+2);}
if(this._menuLevels[level+1]&&this._menuLevels[level+1].CurrentMenuItem)
{this._menuLevels[level+1].CurrentMenuItem._element.className=this.ItemCssClass;this._menuLevels[level+1].CurrentMenuItem=null;}
this._menuLevels[level].CurrentMenuItem._element.className=this.ItemSelectedCssClass;}}
Telligent_PopupMenu.prototype._initialize=function()
{this._menuLevels=new Array();this._menuLevels[0]=new Telligent_PopupMenuLevel(0,null,new Telligent_PopupPanel(this._variableName+'._menuLevels[0]._popupPanel',this.GroupCssClass,this.Position,this.ZIndex,null,new Function('window.'+this._variableName+'.Close(0);'),false,'',new Function('window.'+this._variableName+'._mouseOver();'),new Function('window.'+this._variableName+'._mouseOut();')),this);this._populatePopupPanel(this._menuLevels[0],this._menuItems);this._initialized=true;}
Telligent_PopupMenu.prototype.Refresh=function()
{if(this._initialized)
{var selectedItems=new Array();var i;for(i=0;i<=this._currentLevel;i++)
{selectedItems[i]=this._menuLevels[i].CurrentMenuItem;}
this._populatePopupPanel(this._menuLevels[0],this._menuItems);if(selectedItems.length>0)
{var j;var menuItems=this._menuItems;var found;for(i=0;i<selectedItems.length;i++)
{found=false;for(j=0;menuItems&&j<menuItems.length;j++)
{if(selectedItems[i]==menuItems[j])
{this._itemMouseOver(menuItems[j],i,true);menuItems=menuItems[j]._menuItems;found=true;break;}}
if(!found)
{if(menuItems&&menuItems.length>0)
this.Close(i+1);else
this.Close(i);break;}}}}}
Telligent_PopupMenu.prototype._populatePopupPanel=function(menuLevel,menuItems)
{this._disposeLevel(menuLevel);menuLevel._popupPanel.ClearPanelContent();menuLevel.CurrentMenuItem=null;if(!menuItems||menuItems.length==0)
return;var outerTable=document.createElement('table');outerTable.cellPadding='0';outerTable.cellSpacing='0';outerTable.appendChild(document.createElement('tbody'));var i;var hasIcons=false;var hasExpandable=false;for(i=0;i<menuItems.length;i++)
{if(menuItems[i].IconUrl)
hasIcons=true;if(this.ExpandImageUrl&&menuItems[i]._menuItems&&menuItems[i]._menuItems.length>0)
hasExpandable=true;if(hasIcons&&hasExpandable)
break;}
for(i=0;i<menuItems.length;i++)
{var outerRow=document.createElement('tr');outerTable.childNodes[0].appendChild(outerRow);var container=document.createElement('td');container.className=this.ItemCssClass;container.id=menuItems[i].ID;container._menuItem=menuItems[i];outerRow.appendChild(container);var innerTable=document.createElement('table');innerTable.cellPadding='0';innerTable.cellSpacing='0';innerTable.style.width='100%';innerTable.appendChild(document.createElement('tbody'));container.appendChild(innerTable);var row=document.createElement('tr');innerTable.childNodes[0].appendChild(row);var cell;if(hasIcons)
{cell=document.createElement('td');if(menuItems[i].IconUrl)
{var img=document.createElement('img');img.src=menuItems[i].IconUrl;img.style.paddingRight='4px';if(this.IconHeight)
img.height=this.IconHeight;if(this.IconWidth)
img.width=this.IconWidth;cell.appendChild(img);}
else
{cell.appendChild(document.createElement('div'));cell.childNodes[0].style.paddingRight='4px';if(this.IconHeight)
cell.childNodes[0].style.height=this.IconHeight+'px';if(this.IconWidth)
cell.childNodes[0].style.width=this.IconWidth+'px';}
row.appendChild(cell);}
cell=document.createElement('td');cell.style.whiteSpace='nowrap';cell.width='100%';cell.innerHTML=menuItems[i].Text;row.appendChild(cell);if(hasExpandable)
{cell=document.createElement('td');if(this.ExpandImageUrl&&menuItems[i]._menuItems&&menuItems[i]._menuItems.length>0)
{var img=document.createElement('img');img.src=this.ExpandImageUrl;img.style.paddingLeft='4px';if(this.ExpandImageHeight)
img.height=this.ExpandImageHeight;if(this.ExpandImageWidth)
img.width=this.ExpandImageWidth;cell.appendChild(img);}
else
{cell.appendChild(document.createElement('div'));cell.childNodes[0].style.paddingRight='4px';if(this.ExpandImageHeight)
cell.childNodes[0].style.height=this.ExpandImageHeight+'px';if(this.ExpandImageWidth)
cell.childNodes[0].style.width=this.ExpandImageWidth+'px';}
row.appendChild(cell);}
container.onclick=new Function("return "+this._variableName+"._itemClick(this._menuItem,"+menuLevel._level+");");container.onmouseover=new Function("return "+this._variableName+"._itemMouseOver(this._menuItem,"+menuLevel._level+");");menuItems[i]._element=container;}
menuLevel._popupPanel.AddNodeToPanel(outerTable);}
Telligent_PopupMenu.prototype.ParseMenuItems=function(menuItems)
{this._menuItems=new Array();if(!menuItems||menuItems.length==0)
return;for(var i=0;i<menuItems.length;i++)
{this._menuItems[i]=new Telligent_PopupMenuItem(menuItems[i][0],menuItems[i][1]);this._menuItems[i].NavigateUrl=menuItems[i][2];this._menuItems[i].NavigateTarget=menuItems[i][3];this._menuItems[i].ClientScript=menuItems[i][4];this._menuItems[i].IconUrl=menuItems[i][5];this._menuItems[i]._popupMenu=this;if(menuItems[i][6]&&menuItems[i][6].length>0)
this._menuItems[i].ParseMenuItems(menuItems[i][6]);}}
Telligent_PopupMenu.prototype._documentOnClick=function()
{if(this._isOpen&&!this._menuLevels[this._currentLevel]._popupPanel._isOpening&&!this._cancelClick)
this.Close(0);else
this._cancelClick=false;if(this._originalDocumentOnClick)
this._originalDocumentOnClick();}
Telligent_PopupMenu.prototype.AddItem=function(popupMenuItem)
{this.RemoveItem(popupMenuItem);if(popupMenuItem)
{popupMenuItem._popupMenu=this;popupMenuItem._parentMenuItem=null;this._menuItems[this._menuItems.length]=popupMenuItem;}}
Telligent_PopupMenu.prototype.RemoveItem=function(popupMenuItem)
{var menuItems=new Array();var found=false;for(var i=0;i<this._menuItems.length;i++)
{if(this._menuItems[i]==popupMenuItem)
found=true;else
menuItems[menuItems.length]=this._menuItems[i];}
if(found)
this._menuItems=menuItems;}
Telligent_PopupMenu.prototype.InsertItem=function(popupMenuItem,index)
{this.RemoveItem(popupMenuItem);var menuItems=new Array();var inserted=false;for(var i=0;i<this._menuItems.length;i++)
{if(i==index)
{inserted=true;popupMenuItem._popupMenu=this;popupMenuItem._parentMenuItem=null;menuItems[menuItems.length]=popupMenuItem;}
menuItems[menuItems.length]=this._menuItems[i];}
if(!inserted)
menuItems[menuItems.length]=popupMenuItem;this._menuItems=menuItems;}
Telligent_PopupMenu.prototype.ClearItems=function()
{this._menuItems=new Array();}
Telligent_PopupMenu.prototype.GetItemById=function(id)
{for(var i=0;i<this._menuItems.length;i++)
{if(this._menuItems[i].ID==id)
return this._menuItems[i];else
{var item=this._menuItems[i].GetItemById(id);if(item)
return item;}}
return null;}
Telligent_PopupMenu.prototype.GetItemsByText=function(text)
{var items=new Array();for(var i=0;i<this._menuItems.length;i++)
{if(this._menuItems[i].Text==text)
items[items.length]=this._menuItems[i];var subitems=this._menuItems[i].GetItemsByText(text);for(var j=0;j<subitems.length;j++)
items[items.length]=subitems[j];}
return items;}
Telligent_PopupMenu.prototype.GetItemAtIndex=function(index)
{if(index>=0&&index<this._menuItems.length)
return this._menuItems[index];else
return null;}
Telligent_PopupMenu.prototype.GetCurrentItem=function()
{if(this._currentLevel>-1)
{if(this._menuLevels[this._currentLevel].CurrentMenuItem)
return this._menuLevels[this._currentLevel].CurrentMenuItem;else if(this._currentLevel>0)
return this._menuLevels[this._currentLevel-1].CurrentMenuItem;}
return null;}
Telligent_PopupMenu.prototype.GetCurrentItemAtLevel=function(level)
{if(level>0&&this._currentLevel>=level)
return this._menuLevels[level].CurrentMenuItem;else
return null;}
Telligent_PopupMenu.prototype.GetCurrentLevel=function()
{return this.GetLevel(0);}
Telligent_PopupMenu.prototype.GetLevel=function(level)
{if(level>0&&level>=this._currentLevel)
return this._menuLevels[level];else
return null;}
Telligent_PopupMenu.prototype.GetItemCount=function()
{return this._menuItems.length;}
function Telligent_PopupMenuItem(id,text)
{this.ID=id;this.Text=text;this.NavigateUrl=null;this.NavigateTarget=null;this.ClientScript=null;this.IconUrl=null;this._menuItems=new Array();this._element=null;this._popupMenu=null;this._parentMenuItem=null;}
Telligent_PopupMenuItem.prototype.AddItem=function(popupMenuItem)
{this.RemoveItem(popupMenuItem);if(popupMenuItem)
{popupMenuItem._popupMenu=this._popupMenu;popupMenuItem._parentMenuItem=this;this._menuItems[this._menuItems.length]=popupMenuItem;}}
Telligent_PopupMenuItem.prototype.RemoveItem=function(popupMenuItem)
{var menuItems=new Array();var found=false;for(var i=0;i<this._menuItems.length;i++)
{if(this._menuItems[i]==popupMenuItem)
found=true;else
menuItems[menuItems.length]=this._menuItems[i];}
if(found)
this._menuItems=menuItems;}
Telligent_PopupMenuItem.prototype.ClearItems=function()
{this._menuItems=new Array();}
Telligent_PopupMenuItem.prototype.InsertItem=function(popupMenuItem,index)
{this.RemoveItem(popupMenuItem);var menuItems=new Array();var inserted=false;for(var i=0;i<this._menuItems.length;i++)
{if(i==index)
{inserted=true;popupMenuItem._popupMenu=this._popupMenu;popupMenuItem._parentMenuItem=this;menuItems[menuItems.length]=popupMenuItem;}
menuItems[menuItems.length]=this._menuItems[i];}
if(!inserted)
menuItems[menuItems.length]=popupMenuItem;this._menuItems=menuItems;}
Telligent_PopupMenuItem.prototype.GetItemById=function(id)
{for(var i=0;i<this._menuItems.length;i++)
{if(this._menuItems[i].ID==id)
return this._menuItems[i];else
{var item=this._menuItems[i].GetItemById(id);if(item)
return item;}}
return null;}
Telligent_PopupMenuItem.prototype.GetItemsByText=function(text)
{var items=new Array();for(var i=0;i<this._menuItems.length;i++)
{if(this._menuItems[i].Text==text)
items[items.length]=this._menuItems[i];var subitems=this._menuItems[i].GetItemsByText(text);for(var j=0;j<subitems.length;j++)
items[items.length]=subitems[j];}
return items;}
Telligent_PopupMenuItem.prototype.GetItemAtIndex=function(index)
{if(index>=0&&index<this._menuItems.length)
return this._menuItems[index];else
return null;}
Telligent_PopupMenuItem.prototype.GetPopupMenu=function()
{return this._popupMenu;}
Telligent_PopupMenuItem.prototype.GetParentItem=function()
{return this._parentMenuItem;}
Telligent_PopupMenuItem.prototype.GetItemCount=function()
{return this._menuItems.length;}
Telligent_PopupMenuItem.prototype.ParseMenuItems=function(menuItems)
{this._menuItems=new Array();if(!menuItems||menuItems.length==0)
return;for(var i=0;i<menuItems.length;i++)
{this._menuItems[i]=new Telligent_PopupMenuItem(menuItems[i][0],menuItems[i][1]);this._menuItems[i].NavigateUrl=menuItems[i][2];this._menuItems[i].NavigateTarget=menuItems[i][3];this._menuItems[i].ClientScript=menuItems[i][4];this._menuItems[i].IconUrl=menuItems[i][5];this._menuItems[i]._popupMenu=this;if(menuItems[i][6]&&menuItems[i][6].length>0)
this._menuItems[i].ParseMenuItems(menuItems[i][6]);}}
function Telligent_PopupMenuLevel(level,parentMenuItem,popupPanel,popupMenu)
{this._level=level;this._parentMenuItem=parentMenuItem;this._popupPanel=popupPanel;this._popupMenu=popupMenu;this.CurrentMenuItem=null;}
Telligent_PopupMenuLevel.prototype.GetLevelIndex=function()
{return this._level;}
Telligent_PopupMenuLevel.prototype.GetParentItem=function()
{return this._parentMenuItem;}
Telligent_PopupMenuLevel.prototype.GetPopupMenu=function()
{return this._popupMenu;};