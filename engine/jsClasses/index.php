<?php

	$classes=$_GET['classes'];

	foreach($classes as $class_name)
	{				
		$templates=array();
		$class_dir=__DIR__."/../../js/classes/$class_name";
		$templates_dir="$class_dir/templates";
		$class_url_dir="js/classes/$class_name";
		$abs_url="http://".$_SERVER['HTTP_HOST'].preg_replace('|[^\/]*\/[^\/]*\/[^\/]*\Z|iU', '', $_SERVER['REQUEST_URI']);
		$files=scandir($templates_dir);
		unset($files[0]);
		unset($files[1]);
		foreach($files as $file)
		{		
			$template_name=substr($file, 0, -4);
			$template=array();
			ob_start();
				include $templates_dir.'/'.$file;
			$template_source=ob_get_clean();
			$template['source']=$template_source;
			preg_match_all('/ enginePart=(\w*)/', $template_source, $matches, PREG_SET_ORDER);		
			foreach($matches as $match)
			{
				$template['parts'][]=$match[1];
			}
			$templates[$template_name]=$template;
		}
		
		$js_templates_source='
			this.templates='.json_encode($templates).';
			this.createNode=function(templateName)
			{
				return engineCreateNodeFromTemplate(this, templateName);
			}
		';
		
		include "$class_dir/$class_name.php";
		
		echo "\r\n\r\n";
	}
	
?>