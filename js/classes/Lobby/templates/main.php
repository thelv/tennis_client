<?php
	$ulogin_handler=urlencode($abs_url.'ulogin/ulogin.php');
?>
<div class=Lobby>
	<div class=NetworkClient enginePart=networkClient>
		<!-- networkClient -->
	</div>
	<div class=PrepareGame>	
		<div id=begin enginePart=begin>
			Connecting to server...
		</div>
		<div id=Auth enginePart=auth >
			<div>Recommended to login with one of social networks</div>
			<script src="http://ulogin.ru/js/ulogin.js"></script>
			<a href="#" id="uLogin" x-ulogin-params="display=window;callback=lobbySetAccaunt;fields=first_name,last_name,photo;redirect_uri=<?= $ulogin_handler ?>"><img src="http://ulogin.ru/img/button.png" width=187 height=30 alt="MultiLogin"/></a>
		</div>
		<div id=Profile enginePart=profile >
			<div>You loged in as</div>
			<img enginePart=profileImg />	
			<span enginePart=profileName>
				<!-- name -->
			</span>
			<br>
			<button enginePart=logout>
				Logout
			</button>	
		</div>
		<div id=RefreshPlayersLists enginePart=refreshPlayersLists >
			Refresh players lists
		</div>
		
		<div class="AllPlayersList PlayersList">
			Free Players List
			<div enginePart=allPlayersList>
			</div>
		</div>
		<div class="InvitedByPlayersList PlayersList">
			Invited By Players List
			<div enginePart=invitedByPlayersList>
			</div>
		</div>			
		<div class="InviteWhoPlayersList PlayersList">
			Invite Who Players List
			<div enginePart=inviteWhoPlayersList>
			</div>
		</div>		
	</div>	
	<div id=Game>
		<embed id=flash enginePart=flash src<?php if($_SERVER['HTTP_HOST']!='127.0.0.2') echo ''; ?>="flash/Flash/bin/flash.swf?<?php echo rand(0,10000); ?>" src1<?php if($_SERVER['HTTP_HOST']=='127.0.0.2') echo '1'; ?>="swf/Flash.swf?<?php echo rand(0,10000); ?>" type="application/x-shockwave-flash" allowscriptaccess="always" scale="noscale"></embed>
	</div>
</div>