// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function checkUser(u) 
{
	var r = new Ajax.Updater("check_user", "/usuarios/checkUser?user="+u, {asynchronous:true, evalScripts:true});
}

function checkMail(u) 
{
	var r = new Ajax.Updater("check_mail", "/usuarios/checkMail?mail="+u, {asynchronous:true, evalScripts:true});
}

function carrera(tipo)
{
	if (tipo == "a" || tipo == "e")
	{
		document.getElementById('carrera').style.display = 'inline';
	}
	else
	{
		document.getElementById('carrera').style.display = 'none';
	}
}

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

function blankDiv() {document.getElementById('listaCorreo').innerHTML = '';}

function confirmBlock() {
	var x = confirm('¿Estás seguro que quieres bloquear estas personas?');
	if (x)
	{
		new Ajax.Updater('tmp','/usuarios/blockXlote', {asynchronous:true, evalScripts:true, parameters:Form.serialize(document.forms['lotes'])});				
	}
	else
	{
		alert('Esta persona no se bloqueara.');
	}
	
}

function confirmDelete() {
	var x = confirm('¿Estás seguro que quieres ELIMINAR a estas personas(BLOQUEADAS) para siempre?');
	
	if (x)
	{	
		new Ajax.Updater('tmp','/usuarios/deleteXlote?o=custom', {asynchronous:true, evalScripts:true, parameters:Form.serialize(document.forms['block'])});				
	}
	else
	{
		alert('No se borraran los usuarios.');
	}
}

function confirmDeleteAll() {
	var x = confirm('¿Estás seguro que quieres ELIMINAR a TODAS estas personas(BLOQUEADAS) para siempre?');
	if (x) 
	{
		new Ajax.Updater('tmp','/usuarios/deleteXlote?o=all', {asynchronous:true, evalScripts:true});
	}
	else
	{
		alert('No se borraran los usuarios.');
	}
}


function formChangeType(opt){
	if (opt=="ver")
		document.getElementById("formChangeType").style.display = "inline";
	else
		document.getElementById("formChangeType").style.display = "none";
}	




