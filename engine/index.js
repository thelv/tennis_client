function engineLoadClasses(classes)
{

	$.ajax({
		url: 'engine/jsClasses/index.php',
		async: false,
		dataType: 'html',
		data: {classes: classes, rand: Math.random()},		
		success: function(data) 
		{
			$('body').append($('<script>\r\n'+data+'\r\n</script>'));
		}
	});
}

function engineCreateObject(className)
{	
	//className=className.split('/').join('');
	return new window['Engine'+className];
}

function engineCreateNodeFromTemplate(object, templateName)
{
	var result=new Object();
	result.parts=new Object();
	result.node=$(object.templates[templateName].source);
	for(var i in object.templates[templateName].parts)
	{
		part=object.templates[templateName].parts[i];
		result.parts[part]=result['node'].find('[enginePart='+part+']');
	}
	return result;
}