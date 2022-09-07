fx_version 'cerulean' -- NE PAS TOUCHER
games {'gta5'} -- NE PAS TOUCHER

ui_page 'ui/rHud.html'

files {
	'ui/rHud.html',
	'ui/main.js',
	'ui/style.css',
	'ui/img/typo.png',
}

client_scripts {
	'config.lua',
	'client/hud.lua',
	'client/seatbelt.lua'
}

server_scripts {
	'server/event.lua'
}
