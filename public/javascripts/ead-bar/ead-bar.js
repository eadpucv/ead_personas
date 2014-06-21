(function ( $ ) {
	$.fn.load_ead_bar = function(options) {
		this.prepend("<div id='bar'></div>");
		
		var _loadFile = function(filename, container, errorMessage) {
		    return $.ajax({
		        url : filename,
		        type: "GET",
		        cache: false,
		        dataType: "html",
		        success : function (data) {
		            $(container).html(data);
		        }
		    });
		}

		_loadFile(options.path_js+'bar.html', '#bar', 'errorMessage')
		.then(function() {

	
			// Identificar Credenciales
			if (options.id.length > 0 && options.name.length > 0 && options.mail.length > 0) {
				

				// Asigno Textos y Url's
				$("#ead-bar-dropdown_li").prepend("<a href='#' id='ead_bar_dropdown-session' class='usuario_inactive'><img class='flecha-usuario' src='https://s3.amazonaws.com/Ead/ead_bar_images/icon-user-arrow.gif'>"+ options.name + " " + options.lastname + "</a>");
				$("#ead-bar-dropdown_li-movil").prepend("<a href='#' id='ead_bar_dropdown-session-movil' class='usuario_inactive'><img class='flecha-usuario' src='https://s3.amazonaws.com/Ead/ead_bar_images/icon-user-arrow.gif'>"+ options.name + " " + options.lastname + "</a>");
				
				// Perfil de la Wiki
				if (options.wikipage.length > 0) {
					if (options.wikipage.indexOf("http://wiki.ead.pucv.cl") > -1){
						$("#ead_bar_dropdown-perfil-movil").attr('href',options.wikipage);
						$("#ead_bar_dropdown-perfil").attr('href',options.wikipage);
					} else {
						$("#ead_bar_dropdown-perfil-movil").attr('href',"http://wiki.ead.pucv.cl/index.php?title="+options.wikipage);
						$("#ead_bar_dropdown-perfil").attr('href',"http://wiki.ead.pucv.cl/index.php?title="+options.wikipage);
					}
				} else {
					$("#ead_bar_dropdown-perfil, #ead_bar_dropdown-perfil-movil").on( "click", function() {
						alert("Aun no has definido tu pagina de \"Casiopea\" en tu perfil de personas.");
					});					
				}

				// Admin?				
				if (options.admin === "si") {
					$("#ead_bar_dropdown-admin").attr('href','http://personas.ead.pucv.cl/admin/list');									
					$("#ead_bar_dropdown-admin-movil").attr('href','http://personas.ead.pucv.cl/admin/list');														
				} else {
					$("#ead_bar_dropdown-admin").hide();
					$("#ead_bar_dropdown-admin-movil").hide();					
				}

				// Editar Perfil en Personas
				$("#ead_bar_dropdown-account-movil").attr('href',"http://personas.ead.pucv.cl/user/edit/"+options.id);
				$("#ead_bar_dropdown-account").attr('href',"http://personas.ead.pucv.cl/usuarios/edit/"+options.id);
				
				// Logout
				$("#ead_bar_dropdown-end_session-movil").attr('href',options.site_logout_url);
				$("#ead_bar_dropdown-end_session").attr('href',options.site_logout_url);
				
				// Usuario.
				$("#ead-bar-dropdown_li").click(function(e) {
					if($("#ead_bar_dropdown_sub_ul").is(':visible')) {
						$("#ead_bar_dropdown-session").removeClass( "usuario_active" ).addClass( "usuario_inactive" );
						$("#ead_bar_dropdown_sub_ul").hide();
					} else {
						$("#ead_bar_dropdown-session").removeClass( "usuario_inactive" ).addClass( "usuario_active" );
						$("#ead_bar_dropdown_sub_ul").show();
						e.stopPropagation();
					}
					$( "#ead-bar-dropdown_li" ).blur();
				});

				// Usuario, Menu movil
				$("#ead-bar-dropdown_li-movil").click(function(e) {
					if($("#ead_bar_user_menu-movil").is(':visible')) {
						$("#ead_bar_user_menu-movil").hide();
					} else {
						$("#ead_bar_user_menu-movil").show();
					}
					$( "#ead-bar-dropdown_li-movil" ).blur();
				});				

				// Salir del menu cuando se hace click en otro punto y el menu esta abierto
				$(document).click(function(){
	      		if($("#ead_bar_dropdown_sub_ul").is(':visible')) {
	          		$("#ead_bar_dropdown_sub_ul").hide();
						$("#ead_bar_dropdown-session").removeClass( "usuario_active" ).addClass( "usuario_inactive" );
	      		};
	        	});	


			} else {
				// Habilitar boton y link para iniciar session
				$("#ead-bar-dropdown_li").prepend("<a href='"+options.site_login_url+"' id='ead_bar_dropdown-session' class='iniciarsesion'>Iniciar sesión</a>")
				$("#ead-bar-dropdown_li-movil").prepend("<a href='"+options.site_login_url+"' id='ead_bar_dropdown-session' class='iniciarsesion'>Iniciar sesión</a>")				
			}

			// Identificar Sitio
				$("#link_"+options.site_name).addClass( "active" );			
			});

		return this;
	};
}( jQuery ));