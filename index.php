<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>		
		<meta charset=utf8 />
		<link rel=stylesheet href="css/main.css" type="text/css" />
		<script type="text/javascript" src="js/jquery.js"></script>
		<script type="text/javascript" src="js/jquery.cookie.js"></script>
		<script type="text/javascript" src="js/swfobject.js"></script>
		<script type="text/javascript" src="engine/index.js"></script>										
		<script>
		
			consoleLog=function(message){console.log(message);}
			
			$(document).ready(function() {  
				//загружаем необходимые javascript классы				
				engineLoadClasses(["Lobby"]);
				
				//создаем главный класс и добавляем его на страницу
				lobby=new EngineLobby();
				$('body').append(lobby.node);
			});
		</script>
	</head>
	<body>
		<!-- body -->
	</body>
</html>