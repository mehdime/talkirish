function CallbackPager (varName, containerId, loadPageScript) 
{
	this._variableName = varName;
	this._container = document.getElementById(containerId);
	this._loadPageFunction = new Function('page', 'callback', 'errorCallback', loadPageScript);
	this._isLoading = false;
	
	this.GoToPage = function(page)
	{
	    if (!this._isLoading)
	    {
	        this._container.style.cursor = 'progress';
	        this._isLoading = true;
	        this._loadPageFunction(page, new Function('result', this._variableName + '._updateContent(result);'), new Function(this._variableName + '._error();'));
	    }
	}
	
	this._updateContent = function(result)
	{
	    if (result != null)
	    {
	        Telligent_Common.DisposeContent(this._container);
	    
	        this._container.innerHTML = result;
	    }
	    
	    this._container.style.cursor = 'default';
	    this._isLoading = false;
	}
	
	this._error = function()
	{
	    alert('An error occured while paging');
	    this._isLoading = false;
	    this._container.style.cursor = 'default';
	}
}
