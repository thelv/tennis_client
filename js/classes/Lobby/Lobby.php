EngineLobby=function()
{
	var _this=this;

	<?php echo $js_templates_source; ?>	

	this.mainNode=this.createNode('main');
	this.node=this.mainNode.node;
	console.log(this.mainNode);
	this.flash=this.mainNode.parts.flash[0];
	console.log(this.flash);

	this.mainNode.parts.logout.click(function(){_this.logout();})
	
	this.logout=function()
	{
		$.cookie('accaunt', '', {path: '/'});
		this.accaunt=null;
		this.checkAuth();
	}
	
	this.checkAuth=function()
	{
		var a=$.cookie('accaunt');
		if(a)
		{
			lobbySetAccaunt(a);			
		}
		else
		{
			this.viewShowAuth(true);
		}
	}
	
	window.lobbySetAccaunt=function(a)
	{
		_this.accaunt=JSON.parse(a);
		_this.sendMessage({mt: "accaunt", accaunt: _this.accaunt});
		_this.viewShowAuth(false);
		_this.viewShowProfile();
	}	
	
	this.mainNode.parts.refreshPlayersLists.click(function(){	
		_this.mainNode.parts.allPlayersList.html('').hide().delay(200).fadeIn(0);
		_this.mainNode.parts.invitedByPlayersList.html('').hide().delay(200).fadeIn(0);
		_this.mainNode.parts.inviteWhoPlayersList.html('').hide().delay(200).fadeIn(0);
		_this.sendMessage({mt: 'players_lists'});
	});

	//methods

		//view
		
			//показать авторизацию
			this.viewShowAuth=function(show)
			{						
				this.mainNode.parts.auth.css('display', show ? 'block': 'none');
				this.mainNode.parts.profile.css('display', 'none');
			}
			
			this.viewShowProfile=function()
			{
				this.mainNode.parts.auth.css('display', 'none');				
				this.mainNode.parts.profileName.html(this.accaunt.first_name+' '+this.accaunt.last_name);
				this.mainNode.parts.profileImg.attr('src', this.accaunt.photo);
				this.mainNode.parts.profile.css('display', 'block');
			}
		
			//показать игру/скрыть игру
			this.viewShowGame=function(show){
				if(show)
				{
					this.mainNode.node.attr('showGame', 1);
				}
				else
				{
					this.mainNode.node.attr('showGame', 0);
				}
			}								

		//private
		
			//послать сообщение на сервер
			this.sendMessage=function(message, sendType){
				this.flash.messageSend(message, sendType);
			}	

		//other

			//API для Flash 
				window.networkClientReady=function(success){
					if(success)
					{						
						_this.checkAuth();
						
						//получаем список игроков
						_this.sendMessage({mt: 'players_lists'});
					}
					else
					{
						//alert('Не удалось подключиться к серверу.');
						console.log('Connection error');
					}
				}		

				window.gameDestroy=function()
				{
					_this.exitGame();
				}			
				
				window.networkClientMessageReceive=function(message)
				{
					_this.handleMessage(message);
				}
			
			// ! API для Flash
			
			this.playerInListInviteFunction=function(user){						
				return function(){
					console.log(user);
					_this.sendMessage({mt: 'invite_player', action: 'invite', user: user});
				};
			}
			
			this.playerInListUnInviteFunction=function(user){
				return function(){
					console.log(user);
					_this.sendMessage({mt: 'invite_player', action: 'uninvite', user: user});
				};
			}
			
			//api : обработка сообщений от сервера
			this.handleMessage=function(message){
				if(message.mt=='enter_in_game')
				{
					//успешный вход
					if(message.result=='accepted')
					{				
						this.flash.gameCreate('network', (message.first_serve==1));
						this.viewShowGame(true);
						this.flash.tabIndex=0;
						this.flash.focus();
					}			
					//неудавшийся вход
					else
					{
						alert('Error. Can\'t enter into this game!')
					}			
				}									
				//получить список игроков
				else if(message.mt=='players_lists')
				{
					this.mainNode.parts.begin.css('display', 'none');
				
					//список всех игроков
					this.mainNode.parts.allPlayersList.html('');
					for(var i in message.all_players_list)
					{					
						var playerInList=this.createNode('playerInAllPlayersList');						
						var accaunt=message.all_players_list[i].accaunt;
						//var session=message.all_players_list[i].session;
						var session='';
						var user=message.all_players_list[i].user;					
						playerInList.parts.name.html(accaunt ? accaunt.first_name+' '+accaunt.last_name : 'anonym'+user);
						playerInList.parts.img.attr('src', accaunt ? (accaunt.photo ? accaunt.photo : '') : '');
						playerInList.parts.img.attr('onclick', accaunt ? 'window.open("'+accaunt.profile+'")' : '');
						playerInList.parts.img.attr('title', accaunt ? 'Открыть профиль в социальной сети' : '');					
						playerInList.parts.play.click(this.playerInListInviteFunction(user));
						//playerInList.parts.notPlay.click(this.playerInListUnInviteFunction(user));
						this.mainNode.parts.allPlayersList.append(playerInList.node);
					}
					
					if(message.all_players_list.length==0)
					{
						this.mainNode.parts.allPlayersList.html('<span style="color:gray">empty</span>');
					}
					
					//список приглашенных к игре игроков
					this.mainNode.parts.inviteWhoPlayersList.html('');					
					for(var i in message.invite_who_players_list)
					{					
						var playerInList=this.createNode('playerInInviteWhoPlayersList');						
						var accaunt=message.invite_who_players_list[i].accaunt;
						var session='';
						var user=message.invite_who_players_list[i].user;
						playerInList.parts.name.html(accaunt ? accaunt.first_name+' '+accaunt.last_name : 'anonym'+user);
						playerInList.parts.img.attr('src', accaunt ? (accaunt.photo ? accaunt.photo : '') : '');
						playerInList.parts.img.attr('onclick', accaunt ? 'window.open("'+accaunt.profile+'")' : '');
						playerInList.parts.img.attr('title', accaunt ? 'Открыть профиль в социальной сети' : '');
						/*playerInList.parts.play.click(function(){
							_this.sendMessage({mt: 'invite_player', action: 'invite', vk_id: vkId, session: session, user: user});
						});*/
						/*playerInList.parts.notPlay.click(function(){
							_this.sendMessage({mt: 'invite_player', action: 'uninvite', session: session, user: user});
						});*/
						playerInList.parts.notPlay.click(this.playerInListUnInviteFunction(user));
						this.mainNode.parts.inviteWhoPlayersList.append(playerInList.node);						
					}
					
					if(message.invite_who_players_list==0)
					{
						this.mainNode.parts.inviteWhoPlayersList.html('<span style="color:gray">empty</span>');
					}
					
					//список пригласивших к игре игроков
					this.mainNode.parts.invitedByPlayersList.html('');
					for(var i in message.invited_by_players_list)
					{					
						var playerInList=this.createNode('playerInInvitedByPlayersList');						
						var accaunt=message.invited_by_players_list[i].accaunt;
						var session='';
						var user=message.invited_by_players_list[i].user;
						playerInList.parts.name.html(accaunt ? accaunt.first_name+' '+accaunt.last_name : 'anonym'+user);
						playerInList.parts.img.attr('src', accaunt ? (accaunt.photo ? accaunt.photo : '') : '');
						playerInList.parts.img.attr('onclick', accaunt ? 'window.open("'+accaunt.profile+'")' : '');
						playerInList.parts.img.attr('title', accaunt ? 'Открыть профиль в социальной сети' : '');
						/*playerInList.parts.play.click(function(){
							_this.sendMessage({mt: 'invite_player', action: 'invite', session: session, user: user});
						});*/
						/*playerInList.parts.notPlay.click(function(){
							_this.sendMessage({mt: 'invite_player', action: 'uninvite', vk_id: vkId, session: session, user: user});
						});*/
						playerInList.parts.play.click(this.playerInListInviteFunction(user));
						this.mainNode.parts.invitedByPlayersList.append(playerInList.node);						
					}
					
					if(message.invited_by_players_list==0)
					{
						this.mainNode.parts.invitedByPlayersList.html('<span style="color:gray">empty</span>');
					}
				}				
			}

//for debug 

/*this.synchronizationShift=false;		
//this.sendMessage=function(){};
setTimeout(function(){_this.handleMessage({mt: 'enter_in_game', time: 0, first_serve: true, result: 'accepted'});}, 2000);
//_this.handleMessage({mt: 'enter_in_game', time: 0, first_serve: true, result: 'accepted'});
//this.handleMessage=function(){};//*/
}