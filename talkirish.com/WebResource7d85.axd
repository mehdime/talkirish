function SelectTagsForm (varName, checkboxListContainerId, tagEditorVarName, numberOfColumns) 
{
	this.VariableName = varName;
	this.CheckboxListContainerHandle = document.getElementById(checkboxListContainerId);
	this.NumberOfColumns = numberOfColumns;
	this.TagEditorVariableName = tagEditorVarName;
	
	this.SaveTags = function()
	{
		if (!this.CheckboxListContainerHandle)
			return;
	
		var inputs = document.getElementsByTagName('input');
		var tags = new Array();
		
		for (var i = 0; i < inputs.length; i++)
		{
			if (inputs[i].type == 'checkbox' && inputs[i].name && inputs[i].name.indexOf(this.VariableName) > -1 && inputs[i].checked)
				tags[tags.length] = inputs[i].value;
		}
	
		// save back to tag editor
		var caller = eval('window.parent.' + this.TagEditorVariableName);
		if (caller && caller.SetSelectedTags)
			caller.SetSelectedTags(tags);
		
		// close modal
		window.parent.Telligent_Modal.Close(true);
	}
	
	this.GetAllTagsWithEncoding = function ()
	{
		if (this.TagEditorVariableName != '')
			return eval('window.parent.' + this.TagEditorVariableName + '.GetAllTagsWithEncoding()');
		else
			return new Array();
	}
	
	this.GetSelectedTags = function ()
	{
		if (this.TagEditorVariableName != '')
			return eval('window.parent.' + this.TagEditorVariableName + '.GetSelectedTags()');
		else
			return new Array();
	}
	
	this.Initialize = function()
	{
		if (!this.CheckboxListContainerHandle)
			return;
			
		var content = '<table cellspacing="0" cellpadding="0" border="0" width="100%"><tr>';
		var allTags = this.GetAllTagsWithEncoding();
		var selTags = ';' + this.GetSelectedTags().join(';') + ';'
		selTags = selTags.toLowerCase();
	
		for(var i = 0; i < allTags.length; i++)
		{
			if (i % this.NumberOfColumns == 0)
				content += '</tr><tr>';
				
			content += '<td width="' + (100 / this.NumberOfColumns) + '%"><input id="' + this.VariableName + '_' + i + '" type="checkbox" name="' + this.VariableName + '_' + i + '" ' + ((selTags.indexOf(';' + allTags[i][0].toLowerCase() + ';') > -1) ? 'checked="checked"' : "") + ' value="' + allTags[i][1] + '" /><label for="' + this.VariableName + '_' + i + '">' + allTags[i][1] + '</label></td>';
		}		
		
		content += '</tr></table>';
		
		this.CheckboxListContainerHandle.innerHTML = content;
	}
	
	this.Initialize();
}

