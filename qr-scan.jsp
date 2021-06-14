<%@page import="com.aub.apmt.controller.VisitHelper"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!-- Header -->
<%-- <jsp:include page="header.jsp"></jsp:include> --%>
<%@ include file="header.jsp" %>
<!-- End of Header -->

<c:choose>
    <c:when test="${language=='ar'}">
    <body dir='rtl'>
    </c:when>    
    <c:otherwise>
    <body dir='ltr'>
    </c:otherwise>
</c:choose>

<fmt:requestEncoding value="UTF-8" />
<fmt:setLocale value="${language}" /> 
<fmt:setBundle basename="com.aub.apmt.resources.messages" />

		<%
        String update = ""+((String) request.getAttribute("update"));
		%>


<!-- actual content goes here -->

<div class="container-fluid">
	<div class="row justify-content-center">
		<div class="col-12 col-xs-12 col-sm-11 col-lg-10">
			<form id="msform" action="inquiry" method="POST" name="enquiryForm" autocomplete="off">
				<!-- fieldsets -->
				<fieldset class="animate-plus" data-animations="fadeInUp"
					data-animation-when-visible="true"
					data-animation-reset-offscreen="true">
					<div class="webhead"><fmt:message key="label_inquiry" /></div> 
					<div class="row justify-content-center">
					
						<strong>${status}</strong>	
						<br>
						<div class="col-lg-12">
						</div>
						<div class="col-lg-4">
							<%if("update".equals(update)){ %>
							<%--scanner code start --%>
							
							<fieldset class="innerFieldset">
                        		<legend><fmt:message key="label_appointment_status_hd" /></legend>
								
								<!-- scanner goes here -->
								<div id="qr">
									<div class="placeholder">QR Code Scanner</div>
								</div>
								
								<div class="row">
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
									<div class="form-group">
									<label for="appointmentNumber" id="appointmentNumber"><fmt:message key="label_appointment_number" /></label>
									<div ></div>
									</div>
								</div>
								
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
		                          <div class="form-group">
										<label for="appointment_status" id="status"><fmt:message key="label_appointmentn_status" /></label>
									</div>
								</div>
								
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
									<div class="form-group">
										<label for="branch_name" id="appointmentBranch"><fmt:message key="label_branch" /></label> 
										<div ></div>
										</div>
								</div>
								
		                       	<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
									<div class="form-group">
										<label for="appointmentDate" id="appointmentDate"><fmt:message key="label_appointment_date" /></label> 
										<div ></div>
									</div>
								</div>
								
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
		                          <div class="form-group">
										<label for="appointment_slot_desc" id="appointTime"><fmt:message key="label_appointment_slot_desc" /></label> 
										<div ></div></div>
								</div>
		
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
		                          <div class="form-group">
										<label for="applicant_civilid" id="civilId"><fmt:message key="label_applicant_civilid" /></label> 
										<div ></div>
									</div>
								</div>
								
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
		                          <div class="form-group">
										<label for="applicant_name"  id="name"><fmt:message key="label_customer_applicant" /></label> 
										<div></div>
								  </div>
								</div>
								
								<div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
		                          <div class="form-group">
										<label for="mobileno" id="mobile"><fmt:message key="label_customer_mobile" /></label> 
										<div ></div>
									</div>
								</div>
		
								 <div class=" ${language eq 'ar' ? 'col-lg-4 col-md-4 text-right' : 'col-lg-4 col-md-4 text-left'}">
									<div class="form-group">
										<label for="email" id="email"><fmt:message key="label_customer_email" /></label> 
										<div ></div>
									</div>
								</div>
								</div>
								
								
								<div id="scannedCodeContainer"></div>
								<div id="feedback"></div>
								<div class="scan-type-region camera" id="scanTypeCamera">
									<div>
										<code id="status">
											<strong></strong>
										</code>
										<button id="requestPermission" class="btn btn-success btn-sm">Request Permission</button>
									</div>
									<div>
										<div>
											<div id="selectCameraContainer" style="display: inline-block;"></div>
											<select id="cameraSelection" disabled></select>
										</div>
										<div>
											<button id="scanButton" class="btn btn-success btn-sm" disabled>Scan</button>
											<button id="stopButton" class="btn btn-warning btn-sm" disabled>Cancel</button>
										</div>
									</div>
								</div>
							</fieldset>
							
							<%--scanner code end --%>
							
							<%}else if(!(VisitHelper.isNotNullEmpty((String)request.getAttribute("message")))){ %>
							
							<div style="font-size:15px;">
								<br>
									<img src="images/error.png" width="30px" height="30px">&nbsp&nbsp<%= (String)request.getAttribute("message") %>
							</div>
							<div class="card-cover">
								<br>
								<div class=" form-group ${language eq 'ar' ? 'col-lg-12 text-right' : 'col-lg-12 text-left'}">
									<label for="login_name"><fmt:message key="label_login_name" /></label> 
									<input type="text" name="login_name" id="login_name" class="form-control" maxlength="20" placeholder="<fmt:message key="label_login_name" />">
									<span id="WrongReferenceNoError" class="error"></span>
								</div>
								
								<div class=" form-group ${language eq 'ar' ? 'col-lg-12 text-right' : 'col-lg-12 text-left'}">
									<label for="password"><fmt:message key="label_password" /></label> 
									<input type="password" id="password" name="password" class="form-control" maxlength="20" placeholder="<fmt:message key="label_password" />">
									<span id="WrongCaptchaError" class="error"></span>
								</div>
								
							</div>
							<%}else{ %>
							
							<div class="card-cover">
								<br>
								<div class=" form-group ${language eq 'ar' ? 'col-lg-12 text-right' : 'col-lg-12 text-left'}">
									<label for="login_name"><fmt:message key="label_login_name" /></label> 
									<input type="text" name="login_name" id="login_name" class="form-control" maxlength="20" placeholder="<fmt:message key="label_login_name" />">
									<span id="WrongReferenceNoError" class="error"></span>
								</div>
								
								<div class=" form-group ${language eq 'ar' ? 'col-lg-12 text-right' : 'col-lg-12 text-left'}">
									<label for="password"><fmt:message key="label_password" /></label> 
									<input type="password" id="password" name="password" class="form-control" maxlength="20" placeholder="<fmt:message key="label_password" />">
									<span id="WrongCaptchaError" class="error"></span>
								</div>
								
							</div>
							<%} %>
							
						</div>
					</div>
					
					<%if(!"update".equals(update)){ %>
					<input type="submit" name="action" class="action-button action-button-signin" value="<fmt:message key="label_continue" />" id="inquiryButton"/> 
					<a href="home.jsp" class="action-button-cancel"><fmt:message key="label_cancel" /></a>
					<%}else{ %>
					<a href="home.jsp" class="action-button-cancel"><fmt:message key="label_cancel" /></a>
					<%} %>
					<input type="hidden" name="br_action" value="br_action" id="br_action"/> 
				</fieldset>
			</form>
		</div>
	</div>
</div>
<!-- Footer -->
<jsp:include page="footer.jsp"></jsp:include>
<script src="./js/html5-qrcode.min.js"></script>
<script src="./js/qrscanner.js"></script>
<!-- End of Footer -->
