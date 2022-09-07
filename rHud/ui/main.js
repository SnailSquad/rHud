$('#showspeedo').hide();
$('#showseatbelt').hide();

$(function(){
	window.addEventListener('message', function(event) {
		if (event.data.actionhud == "showhud"){
			if (event.data.showhud){
				$('#showhud').fadeIn(200);
			} else{
				$('#showhud').fadeOut(800);
			}
		}else if (event.data.actionspeedo == "showspeedo"){
			if (event.data.showspeedo){
				$('#showspeedo').fadeIn(200);
			} else{
				$('#showspeedo').fadeOut(800);
			}
		}else if (event.data.actionseatbelt == "showseatbelt"){
			if (event.data.showseatbelt){
				$('#showseatbelt').fadeIn(200);
			} else{
				$('#showseatbelt').fadeOut(800);
			}
		}
		if (event.data.actionspeedo == "setValue"){
			if (event.data.key == "speed"){
				$(".speed").html(Math.round(event.data.value));
            }else if (event.data.key == "fuel"){
                $(".progressfuel").css("width", (event.data.value) + "%");
				
			}else if (event.data.key == "gear"){
				if (event.data.value === 0 && event.data.vitesse >= 2) {
					$(".gear").html("R");
				}else if (event.data.value === 0 && event.data.vitesse < 2) {
					$(".gear").html("N");
				} else {
					$(".gear").html(Math.round(event.data.value) + "");
				}
            }else if (event.data.key == "gear2"){
				if (event.data.value === 0 && event.data.vitesse >= 2) {
					$(".gear").html("N");
				}else if (event.data.value === 0 && event.data.vitesse < 2) {
					$(".gear").html("N");
				} else {
					$(".gear").html(Math.round(event.data.value) + "");
				}
            }
		}else if (event.data.actionhud == "setValue"){
			if (event.data.key == "money"){
				$(".money").html(event.data.value);
            }else if (event.data.key == "sale"){
				$(".sale").html(event.data.value);
            }else if (event.data.key == "job"){
				$(".job").html(event.data.value);
            }else if (event.data.key == "health"){
                $(".progresshealth").css("width", (event.data.value) + "%");
			}else if (event.data.key == "shield"){
				if (event.data.value < 2){
					$('.shield').hide();
				}else{
					$("progressshield").css("width", (event.data.value) + "%");
				}
                $("progressshield").css("width", (event.data.value) + "%");
			}else if (event.data.key == "eat"){
				$(".progresseat").css("width", (event.data.value) + "%");
			}else if (event.data.key == "drink"){
                $(".progressdrink").css("width", (event.data.value) + "%");
			}
		}
	})
})