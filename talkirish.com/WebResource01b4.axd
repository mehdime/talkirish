ClickPopup = new Object();
ClickPopup._variableName = "ClickPopup";
ClickPopup._popupPanel = null;
ClickPopup._currentElement = null;
ClickPopup._initialized = false;
ClickPopup._currentElementInfo = null;

ClickPopup.Register = function(id, html, cssClass, hoverCssClass)
{
	var element = document.getElementById(id);
	if (element)
	{
		element._clickPopup_html = html;
		element._clickPopup_cssClass = cssClass;
		element._clickPopup_activeCssClass = hoverCssClass;
		element.onclick = new Function(this._variableName + '.Show(this);');
	}
}

ClickPopup.Show = function(element)
{
	if (!this._initialized)
		this._initialize();
		
	if (element == this._currentElement)
	{
	    this._hide();
		return;
	}
	
	this._hide();
		
	this._currentElement = element;
	this._currentElement.className = this._currentElement._clickPopup_activeCssClass;
	this._currentElementInfo = Telligent_Common.GetElementInfo(this._currentElement);
	
	this._popupPanel.SetPanelContent(this._currentElement._clickPopup_html);
	this._popupPanel.Refresh();
	this._popupPanel.ShowAtElement(this._currentElement);	
}

ClickPopup._hide = function()
{
	if (this._initialized && this._popupPanel.IsShown())
		this._popupPanel.Hide();
}

ClickPopup._popupClosed = function()
{
    if (this._currentElement)
		this._currentElement.className = this._currentElement._clickPopup_cssClass;
	
	this._currentElement = null;
	this._currentElementInfo = null;
}

ClickPopup._initialize = function()
{
	this._popupPanel = new Telligent_PopupPanel(this._variableName + '._popupPanel', '', 'updown', 100, null, new Function('ClickPopup._popupClosed();'), true, '');
	this._popupPanel._initialize();
	this._initialized = true;
}
