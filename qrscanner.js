


function docReady(fn) {
    if (document.readyState === "complete" || document.readyState === "interactive") {
        setTimeout(fn, 1);
    } else {
        document.addEventListener("DOMContentLoaded", fn);
    }
}
docReady(function() {
    
	const scanRegionCamera = document.getElementById('scanTypeCamera');
    const scanButton = document.getElementById('scanButton');
    const stopButton = document.getElementById('stopButton');
    const requestPermissionButton = document.getElementById('requestPermission');
    const selectCameraContainer = document.getElementById('selectCameraContainer');
    const cameraSelection = document.getElementById('cameraSelection');
    const scannedCodeContainer = document.getElementById('scannedCodeContainer');
    const feedbackContainer = document.getElementById('feedback');
    const statusContainer = document.getElementById('status');
    const SCAN_TYPE_CAMERA = "camera";
    const html5QrCode = new Html5Qrcode("qr", true);
    
    var currentScanTypeSelection = SCAN_TYPE_CAMERA;
    var codesFound = 0;
    var lastMessageFound = null;
    
    const setPlaceholder = () => {
        const placeholder = document.createElement("div");
        placeholder.innerHTML = "QR viewfinder comes here";
        placeholder.className = "placeholder";
        document.getElementById('qr').appendChild(placeholder);
    }
    const setFeedback = message => {
        feedbackContainer.innerHTML = message;
    }
    const setStatus = status => {
        statusContainer.innerHTML = status;
    }
    
    const qrCodeSuccessCallback = qrCodeMessage => {
        
    	setStatus("Pattern Found");
        console.log('The QR Code Value is :'+qrCodeMessage);
        setFeedback("");
        var qr = qrCodeMessage.substring(qrCodeMessage.indexOf("?")+1);
        $.ajax({
        	url     : '/bookmyvisit/scanner',
        	method     : 'POST',
        	data     : {qr : qr},
        	success    : function(data, textStatus, jqXHR){
        		var obj = jQuery.parseJSON(data);
        		
        		$('#appointmentNumber').append(' <b>'+obj.appointmentNumber);
        		$('#appointmentDate').append(' <b>'+obj.appointmentDate);
    			$('#appointTime').append(' <b>'+obj.appointmentTime);
    			$('#appointmentBranch').append(' <b>'+obj.branch+ '<b>');
    			$('#civilId').append(' <b>'+obj.civilId+'<b>');
    			$('#name').append(' <b>'+obj.name+'<b>');
    			$('#mobile').append(' <b>'+obj.mobile+'<b>');
    			$('#email').append(' '+obj.email);
    			$('#status').append(' <b style="color: green;">'+obj.appointmentStatus+'<b>');
        	},
        	error : function(data, textStatus, jqXHR){
        		console.log("Error in Request/Response: " + textStatus);
                $("#ajaxResponse").html(jqXHR.responseText);
        	}
        	});
        //window.open(qrCodeMessage, '_blank');
        if (lastMessageFound === qrCodeMessage.toLocaleLowerCase()) {
            return;
        }
        
        ++codesFound;
        lastMessageFound = qrCodeMessage.toLocaleLowerCase();
    }
    const qrCodeErrorCallback = message => {
        setStatus("Scanning");
    }
    const videoErrorCallback = message => {
        setFeedback(`Video Error, error = ${message}`);
    }
    const classExists = (element, needle) => {
        const classList = element.classList;
        for (var i = 0; i < classList.length; i++) {
            if (classList[i] == needle) {
                return true;
            }
        }
        return false;
    }
    const addClass = (element, className) => {
        if (!element || !className) throw "Both element and className mandatory";
        if (classExists(element, className)) return;
        element.classList.add(className);
    };
    const removeClass = (element, className) => {
        if (!element || !className) throw "Both element and className mandatory";
        if (!classExists(element, className)) return;
        element.classList.remove(className);
    }
    const onScanTypeSelectionChange = event => {
        const setupFileOption = () => {
            currentScanTypeSelection = SCAN_TYPE_FILE;
            html5QrCode.clear();
            setPlaceholder();
            if (stopButton.disabled != true) {
                stopButton.click();
            }
            addClass(scanRegionCamera, "disabled");
            removeClass(scanRegionFile, "disabled");
            qrFileInput.disabled = false;
            setFeedback("Select image file to scan QR code.");
        }
        const setupCameraOption = () => {
            currentScanTypeSelection = SCAN_TYPE_CAMERA;
            html5QrCode.clear();
            setPlaceholder();
            qrFileInput.value = "";
            qrFileInput.disabled = true;
            removeClass(scanRegionCamera, "disabled");
            addClass(scanRegionFile, "disabled");
            setFeedback("Click 'Start Scanning' to <b>start scanning QR Code</b>");
        }
        const val = event.target.value;
        if (val == 'camera') {
            setupCameraOption();
        } else {
            throw `Unsupported scan type ${val}`;
        }
    }
    document.querySelectorAll("input[name='scan-type']").forEach(input => {
        input.addEventListener('change', onScanTypeSelectionChange);
    });
    
    requestPermissionButton.addEventListener('click', function() {
    	
        if (currentScanTypeSelection != SCAN_TYPE_CAMERA) return;
        requestPermissionButton.disabled = true;
        
        Html5Qrcode.getCameras().then(cameras => {
            selectCameraContainer.innerHTML = `Select Camera (${cameras.length})`;
            if (cameras.length == 0) {
                return setFeedback("Error: No cameras found in the device");
            }
            for (var i = 0; i < cameras.length; i++) {
                const camera = cameras[i];
                const value = camera.id;
                const name = camera.label == null ? value : camera.label;
                const option = document.createElement('option');
                option.value = value;
                option.innerHTML = name;
                cameraSelection.appendChild(option);
            }
            cameraSelection.disabled = false;
            scanButton.disabled = false;
            
            scanButton.addEventListener('click', () => {
            	
                if (currentScanTypeSelection != SCAN_TYPE_CAMERA) return;
                const cameraId = cameraSelection.value;
                cameraSelection.disabled = true;
                scanButton.disabled = true;
                // Start scanning.
                html5QrCode.start(
                    cameraId,
                    {
                        fps: 10,
                        qrbox: 250
                    },
                    qrCodeSuccessCallback,
                    qrCodeErrorCallback)
                    .then(_ => {
                        stopButton.disabled = false;
                        setStatus("scanning");
                        setFeedback("");
                    })
                    .catch(error => {
                        cameraSelection.disabled = false;
                        scanButton.disabled = false;
                        videoErrorCallback(error);
                    });
                
             // remove sample code in prod.
             /*   $.ajax({
                	url     : '/bookmyvisit/scanner',
                	method     : 'POST',
                	data     : {qr : 'qr=hCDOCPA47CIh/IdcNZ5VJg=='},
                	success    : function(data, textStatus, jqXHR){
                		var obj = jQuery.parseJSON(data);
                		
                		$('#appointmentNumber').append(' <b>'+obj.appointmentNumber);
                		$('#appointmentDate').append(' <b>'+obj.appointmentDate);
            			$('#appointTime').append(' <b>'+obj.appointmentTime);
            			$('#appointmentBranch').append(' <b>'+obj.branch+ '<b>');
            			$('#civilId').append(' <b>'+obj.civilId+'<b>');
            			$('#name').append(' <b>'+obj.name+'<b>');
            			$('#mobile').append(' <b>'+obj.mobile+'<b>');
            			$('#email').append(' '+obj.email);
            			$('#status').append(' <b style="color: green;">'+obj.appointmentStatus+'<b>');
                	},
                	error : function(data, textStatus, jqXHR){
                		console.log("Error in Request/Response: " + textStatus);
                        $("#ajaxResponse").html(jqXHR.responseText);
                	}
                	});*/
            	
            	//sample code end
            });
            
            stopButton.addEventListener('click', function() {
                stopButton.disabled = true;
                html5QrCode.stop().then(ignore => {
                    cameraSelection.disabled = false;
                    scanButton.disabled = false;
                    setFeedback('Stopped');
                    setFeedback("Click 'Start Scanning' to <b>start scanning QR Code</b>");
                    scannedCodeContainer.innerHTML = "";
                    setPlaceholder();
                }).catch(err => {
                    stopButton.disabled = false;
                    setFeedback('Error');
                    setFeedback("Race condition, unable to close the scan.");
                });
            });
        }).catch(err => {
            requestPermissionButton.disabled = false;
            setFeedback(`Error: Unable to query any cameras. Reason: ${err}`);
        });
    });
});
