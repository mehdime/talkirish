function ScrollingPager (varName, containerId, stateId, itemWidth, itemHeight, loadingContent, loadContentFunction, itemsPerPage, pageCount, itemCount, initialItemsId) 
{
	this._variableName = varName;
	this._container = document.getElementById(containerId);
	this._itemsContainer = null;
	this._itemWidth = itemWidth;
	this._itemHeight = itemHeight;
	this._loadContentFunction = loadContentFunction;	
	this._initialized = false;
	this._animationTimeoutHandle = null;
	this._items = new Array();
	this._itemsPerPage = itemsPerPage;
	this._pageCount = pageCount;
	this._itemCount = itemCount;
	this._pages = new Array(this._pageCount);
	this._loadingContent = loadingContent;
	this._state = document.getElementById(stateId);
	this._initialPageIndex = parseInt(this._state.value.split(':')[0]);
	this._firstIndexDisplayed = parseInt(this._state.value.split(':')[1]);
	
	this._initialItemsContainer = document.getElementById(initialItemsId);
	
	this.ScrollStepTimeout = 49;
	this.ScrollStepAcceleration = 1.33;
	this.ScrollInitialDistanceDivisor = 40;

	this.GetCurrentIndex = function()
	{
		return this._firstIndexDisplayed;
	}
	
	this.GetItemCount = function()
	{
	    return this._itemCount;
	}

	this.MovePrevious = function ()
	{
		if (this._initialized && this._firstIndexDisplayed > 0)
		{
			this._firstIndexDisplayed--;
			this.Refresh();
		}
	}
	
	this.MoveNext = function ()
	{
		if (this._initialized && this._firstIndexDisplayed < this._itemCount - 1)
		{
			this._firstIndexDisplayed++;
			this.Refresh();
		}
	}
	
	this.MoveNextPage = function()
	{
		if (this._initialized)
		{
			var offset = Math.floor(this._container.offsetWidth / this._itemWidth);
			if (offset == 0)
				offset = 1;
				
			if (this._firstIndexDisplayed + offset <= this._itemCount - 1)
			{	
				this._firstIndexDisplayed += offset;
				this.Refresh();
			}
		}
	}
	
	this.MovePreviousPage = function()
	{
		if (this._initialized && this._firstIndexDisplayed > 0)
		{
			var offset = Math.floor(this._container.offsetWidth / this._itemWidth);
			if (offset == 0)
				offset = 1;
			
			if (this._firstIndexDisplayed - offset >= 0)
				this._firstIndexDisplayed -= offset;
			else
				this._firstIndexDisplayed = 0;
		
			this.Refresh();
		}
	}
	
	this.MoveTo = function (index)
	{
		if (this._initialized && index >= 0 && index <= this._itemCount - 1)
		{
			this._firstIndexDisplayed = index;
			this.Refresh();
		}
	}
	
	this.MoveFirst = function ()
	{
		if (this._initialized)
		{
			this._firstIndexDisplayed = 0;
			this.Refresh();
		}
	}
	
	this.MoveLast = function ()
	{
		if (this._initialized)
		{
			this._firstIndexDisplayed = this._itemCount - 1;
			this.Refresh();
		}
	}
	
	this.Refresh = function()
	{
		if (this._initialized && this._firstIndexDisplayed >= 0)
		{
			if (this._animationTimeoutHandle)
				window.clearTimeout(this._animationTimeoutHandle);
			
			var currentX = parseInt(this._itemsContainer.style.left, 10);
			var targetX = -(this._firstIndexDisplayed * this._itemWidth);

			var pageOffset = Math.floor(this._firstIndexDisplayed / this._itemsPerPage);
			var itemsDisplayed = this._itemsPerPage - (this._firstIndexDisplayed % this._itemsPerPage);
			var page = 0;
			this._loadPage(page + pageOffset);
			this._setCurrentPage(page + pageOffset, this._firstIndexDisplayed);
			while ((itemsDisplayed + (page * this._itemsPerPage)) * this._itemWidth <= this._container.offsetWidth && page + 1 + pageOffset < this._pageCount)
			{
				this._loadPage(page + 1 + pageOffset);
				page++;
			}

			if (currentX != targetX)
			{			
				var direction = 1;
				if (currentX > targetX)
					direction = -1;
				
				var step = Math.abs(targetX - currentX) / this.ScrollInitialDistanceDivisor;
				this._animationTimeoutHandle = window.setTimeout('window.' + this._variableName + '._moveAnimation(' + direction + ', ' + step + ');', this.ScrollStepTimeout);
			}
		}
	}
	
	this._moveAnimation = function(direction, step)
	{
		if (this._initialized)
		{
			var currentX = parseInt(this._itemsContainer.style.left, 10);
			var targetX = -(this._firstIndexDisplayed * this._itemWidth);
			var done = false;
			var movement = Math.round(direction * step);
			if (Math.abs(targetX - currentX) < step)
			{
				movement = targetX - currentX;
				done = true;
			}
		
			this._itemsContainer.style.left = (currentX + movement) + 'px';
			
			if (!done)
			{
				step *= this.ScrollStepAcceleration;
				if (step < 1)
					step = 1;
					
				this._animationTimeoutHandle = window.setTimeout('window.' + this._variableName + '._moveAnimation(' + direction + ',' + step + ');', this.ScrollStepTimeout);
			}
		}
	}

	this._initialize = function()
	{
		this._initialized = false;	
		
		while (this._container.childNodes.length > 0)
		{
		    if (this._container.childNodes[0] != this._state)
			    this._container.removeChild(this._container.childNodes[0]);	
	    }
		
		this._container.style.position = 'relative';
		this._container.style.overflow = 'hidden';
		this._container.style.height = this._itemHeight + 'px';
		this._container.style.width = '100%';
		
		this._itemsContainer = document.createElement('div');
		this._itemsContainer.style.position = 'absolute';
		this._itemsContainer.style.height = this._itemHeight + 'px';
		this._itemsContainer.style.left = (-(this._firstIndexDisplayed * this._itemWidth)) + 'px';
		this._itemsContainer.style.top = '0px';
		this._container.appendChild(this._itemsContainer);

		this._initialized = true;			
		
		if (this._initialItemsContainer)
		{
		    this._pages[this._initialPageIndex] = 'loaded';
	        for (var i = 0; i < this._initialItemsContainer.childNodes.length; i++)
	        {
	            var e = this._updateItem((this._initialPageIndex * this._itemsPerPage) + i, "");
                for (var j = 0; j < this._initialItemsContainer.childNodes[i].childNodes.length;)
                {
                    e.appendChild(this._initialItemsContainer.childNodes[i].childNodes[j]);
                }
	        }
		    
	        this._initialItemsContainer.parentNode.removeChild(this._initialItemsContainer);
		}
		
		this.Refresh();
	}
	
	this._setCurrentPage = function(page, index)
	{
	    if (this._initialized)
	    {
	        if (page + ':' + index != this._state.value)
	        {
	            this._state.value = page + ':' + index;
	            
	            try
	            {
	                __theFormPostData = ''; 
	                __theFormPostCollection = new Array(); 
	                WebForm_InitCallback();
	            }
	            catch (e) {}
	        }
	    }
	}
	
	this.AddContent = function(page, items)
	{
		this._pages[page] = 'loaded';
		var startIndex = page * this._itemsPerPage;
		
		for (var i = 0; i < items.length; i++)
		{
			this._updateItem(startIndex + i, items[i]);
		}
	}
	
	this._updateItem = function(index, content)
	{
		var insertBeforeNode = null;
		var i;
		
		for (i = index; i < this._items.length; i++)
		{
			if (this._items[i])
			{
				insertBeforeNode = this._items[i];
				break;
			}
		}
		
		if (!this._items[index])
		{
			this._items[index] = document.createElement('div');
			this._items[index].style.width = this._itemWidth + 'px';
			this._items[index].style.height = this._itemHeight + 'px';
			this._items[index].style.position = 'absolute';
			this._items[index].style.overflow = 'hidden';
			this._items[index].style.top = '0px';
			this._items[index].style.left = (index * this._itemWidth) + 'px';
			this._items[index].onmouseover = new Function(this._variableName + '._setCurrentPage(' + Math.floor(index / this._itemsPerPage) + ',' + index + ');');
			if (insertBeforeNode)
				this._itemsContainer.insertBefore(this._items[index], insertBeforeNode);
			else
				this._itemsContainer.appendChild(this._items[index]);
		}
		
		this._items[index].innerHTML = content;
		
		return this._items[index];
	}
	
	this._loadPage = function(page)
	{
		if (!this._pages[page])
		{
			this._pages[page] = 'loading';
			
			for (var i = page * this._itemsPerPage; i < (page + 1) * this._itemsPerPage && i < this._itemCount; i++)
			{
				this._updateItem(i, this._loadingContent);
			}			
			
			this._loadContentFunction(page, new Function('result', this._variableName + '.AddContent(' + page + ', eval(result));'));		
		}
	}
	
	setTimeout(new Function(this._variableName + '._initialize();'), 19);
}
