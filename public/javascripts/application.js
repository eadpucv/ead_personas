function carrera(tipo)
{
	if (tipo == "a" || tipo == "e") { $('#carrera').show(); } else { $('#carrera').hide();}
}


$(document).ready(function() {

	// Cambiar tipo de persona
	$( "#btn_change_type" ).click(function() {
		var resp = confirm('¿Estás seguro que quieres cambiar el tipo de personas?');
	   if (resp) {
		   $.ajax({
	      	type: 'POST',
	      	cache: false,
	      	url: '/admin/changeUserType',
	      	data: $('#lotes').serialize(), 
	      	success: function(msg) {
	         	// Actualizar Dom
	      		$.each(JSON.parse(msg), function(index, value) {
       				$('#tipo_u_'+value[0]).html(value[1]);
   				});
   				$('#formChangeType').remove();

				}
			});
	   }
	});

	// Generar Lista
	$( "#btn_list" ).click(function() {
	   $.ajax({
      	type: 'POST',
      	cache: false,
      	url: '/admin/makeMailList',
      	data: $('#lotes').serialize(), 
      	success: function(msg) {
         	// Actualizar Dom
         	$("#someResults").html(msg);
			}
		});
	});

	// Bloquear usuarios
	$( "#btn_block" ).click(function() {
		var resp = confirm('¿Estás seguro que quieres bloquear estas personas?');
	   if (resp) {
		   $.ajax({
	      	type: 'POST',
	      	cache: false,
	      	url: '/admin/blockXlote',
	      	data: $('#lotes').serialize(), 
	      	success: function(msg) {
	      		$.each(JSON.parse(msg), function(index, value) {
       				$('#u_'+value).remove();
   				});
				}
			});
	   }
	});

	// Eliminar usuarios bloqueados
	$( "#delete_selected_blocked" ).click(function() {
		var resp = confirm('¿Estás seguro que quieres eliminar a estos usuarios bloqueados?');
	   if (resp) {
		   $.ajax({
	      	type: 'POST',
	      	cache: false,
	      	url: '/admin/deleteXlote?o=custom',
	      	data: $('#block').serialize(), 
	      	success: function(msg) {
	      		$.each(JSON.parse(msg), function(index, value) {
       				$('#u_'+value).remove();
   				});
				}
			});
	   }
	});	

	// Eliminar TODOS los usuarios bloqueados
	$( "#delete_all_blocked" ).click(function() {
		var resp = confirm('¿Estás seguro que quieres eliminar a TODOS los usuarios bloqueados?');
	   if (resp) {
		   $.ajax({
	      	type: 'POST',
	      	cache: false,
	      	url: '/admin/deleteXlote?o=all',
	      	data: $('#block').serialize(), 
	      	success: function(msg) {
	         	$("#fd-table-1 > tbody").html("");
				}
			});
	   }
	});

	// Eliminar TODOS los usuarios bloqueados
	$( "#btn_make_list" ).click(function() {
	   $.ajax({
      	type: 'POST',
      	cache: false,
      	url: '/admin/maillistgenerator',
      	data: $('#listaCorreo').serialize(), 
      	success: function(msg) {
         	$("#lc").html(msg);
			}
		});
	});

	// checkUser
	$( "#username_field" ).keyup(function() {
	   $.ajax({
      	type: 'POST',
      	cache: false,
      	url: '/user/checkUser?user='+$( "#username_field" ).val(), 
      	success: function(msg) {
         	$("#check_user").html(msg);
			}
		});
	});

	// checkMail
	$( "#email_field" ).keyup(function() {
	   $.ajax({
      	type: 'POST',
      	cache: false,
      	url: '/user/checkMail?mail='+$( "#email_field" ).val(), 
      	success: function(msg) {
         	$("#check_mail").html(msg);
			}
		});
	});	

});

function checkPass() 
{
	var primera = document.getElementById('usuario_contrasena').value;
	var segunda = document.getElementById('contrasena_rep').value;
	if (primera == segunda)
		{
			document.getElementById('enviar').style.display = 'inline';
			document.getElementById('passwordNotify').innerHTML = '<b style="color:green;">coinciden</strong>';
		}
	else
		{
			document.getElementById('passwordNotify').innerHTML = '<b style="color:red;">No coinciden</strong>';
		}
}