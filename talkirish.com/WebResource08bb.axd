function CollapsableArea (varName, parameter, isExpanded, enableDoubleClick, callbackOnCollapse, callbackOnExpand, headerExpandedCssClass, headerCollapsedCssClass, headerProcessingCssClass, enableProcessingAnimation, ajaxFunction)
{
	this.VariableName = varName;
	this.HeaderHandle = document.getElementById(varName + '_Header');
	this.ContentHandle = document.getElementById(varName + '_Content');
	this.IsExpanded = isExpanded;
	this.IsLoaded = isExpanded;
	this.Parameter = parameter;
	this.EnableDoubleClick = enableDoubleClick;
	this.CallbackOnCollapse = callbackOnCollapse;
	this.CallbackOnExpand = callbackOnExpand;
	this.HeaderExpandedCssClass = headerExpandedCssClass;
	this.HeaderCollapsedCssClass = headerCollapsedCssClass;
	this.HeaderProcessingCssClass = headerProcessingCssClass;
	this.EnableProcessingAnimation = enableProcessingAnimation;
	this.IsProcessing = false;
	this.AnimationTimeoutHandle = null;
	this.AjaxFunction = ajaxFunction;

	this.StartAnimation = function()
	{
		if (this.HeaderHandle)
		{
			this.HeaderHandle.className = this.HeaderProcessingCssClass;
			this.AnimationTimeoutHandle = window.setTimeout('window.' + this.VariableName + '.DoAnimation();', 249);
		}
	}
	
	this.DoAnimation = function()
	{
		window.clearTimeout(this.AnimationTimeoutHandle);
		
		if (this.HeaderHandle && this.IsProcessing)
		{
			window.document.body.style.cursor = 'progress';
		
			if (this.HeaderHandle.className == this.HeaderProcessingCssClass)
			{
				if (this.IsExpanded)
					this.HeaderHandle.className = this.HeaderExpandedCssClass;
				else
					this.HeaderHandle.className = this.HeaderCollapsedCssClass;
			}
			else
				this.HeaderHandle.className = this.HeaderProcessingCssClass;
		
			this.AnimationTimeoutHandle = window.setTimeout('window.' + this.VariableName + '.DoAnimation();', 249);
		}
	}
	
	this.Collapse = function()
	{
		if (this.IsExpanded)
		{
			if (this.CallbackOnCollapse)
			{
				this.IsProcessing = true;
				if (this.EnableProcessingAnimation)
					this.StartAnimation();
				else if (this.HeaderHandle)
					this.HeaderHandle.className = this.HeaderProcessingCssClass;
					
				window.document.body.style.cursor = 'progress';
				this.AjaxFunction('collapsed', '0', this.Parameter, new Function('result', 'window.' + this.VariableName + '.DoCollapse(result);'));
			}
			else
				this.DoCollapse();
		}
	}
	
	this.DoCollapse = function(result)
	{
		this.IsProcessing = false;
	
		if (result && result.error)
			alert(result.error);
		else if (this.ContentHandle)
		{
			this.IsExpanded = false;
			this.ContentHandle.style.display = 'none';
		}
		
		if (this.HeaderHandle)
		{
			if (this.IsExpanded)
				this.HeaderHandle.className = this.HeaderExpandedCssClass;
			else
				this.HeaderHandle.className = this.HeaderCollapsedCssClass;
		}
		
		window.document.body.style.cursor = 'auto';
	}
	
	this.Expand = function()
	{
		if (!this.IsExpanded)
		{
			if (this.CallbackOnExpand || !this.IsLoaded)
			{
				this.IsProcessing = true;
				if (this.EnableProcessingAnimation)
					this.StartAnimation();
				else if (this.HeaderHandle)
					this.HeaderHandle.className = this.HeaderProcessingCssClass;
					
				window.document.body.style.cursor = 'progress';
				this.AjaxFunction('expanded', this.IsLoaded ? '1' : '0', this.Parameter, new Function('result', 'window.' + this.VariableName + '.DoExpand(result);'));
			}
			else
				this.DoExpand();
		}
	}
	
	this.DoExpand = function(result)
	{
		this.IsProcessing = false;
	
        if (this.ContentHandle)
		{
			this.IsExpanded = true;
		
			if (result)
			{
				this.IsLoaded = true;
				this.ContentHandle.innerHTML = result;
			}
				
			this.ContentHandle.style.display = 'block';
		}	
		
		if (this.HeaderHandle)
		{
			if (this.IsExpanded)
				this.HeaderHandle.className = this.HeaderExpandedCssClass;
			else
				this.HeaderHandle.className = this.HeaderCollapsedCssClass;
		}
		
		window.document.body.style.cursor = 'auto';
	}
	
	this.ToggleCollapseExpand = function()
	{
		if (this.IsExpanded)
			this.Collapse();
		else
			this.Expand();
	}
	
	if (this.HeaderHandle && this.EnableDoubleClick)
		this.HeaderHandle.ondblclick = new Function('window.' + this.VariableName + '.ToggleCollapseExpand()');
}