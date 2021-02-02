package com.advanta.controllers
{
	import com.advanta.events.AddAppointmentEvent;
	import com.advanta.events.AppointmentEvent;
	import com.advanta.events.PersonEvent;
	import com.advanta.events.SessionEvent;
	import com.advanta.events.StaffMaintenanceEvent;
	import com.advanta.events.PanelMemberEvent;
	import com.advanta.models.ApplicationModel;
	import com.advanta.models.CaseModel;
	import com.advanta.models.EventModel;
	import com.advanta.models.PersonModel;
	import com.advanta.models.ServiceModel;
	import com.advanta.models.StaffMaintenanceModel;
	import com.advanta.models.AttorneyModel;
	import com.advanta.services.ServiceLocator;
	
	import flash.net.SharedObject;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.ResultEvent;
	
	import spark.formatters.DateTimeFormatter;
	
	import org.flexunit.runner.Result;
	
	
	
	public class PersonController
	{
		private static var _instance:PersonController; 
		
		private var eventModel:EventModel = EventModel.getInstance(); 
		
		private var personModel:PersonModel = PersonModel.getInstance(); 
		
		private var serviceLocator:ServiceLocator = ServiceLocator.getInstance(); 

		private var serviceModel:ServiceModel = ServiceModel.getInstance(); 

		private var staffMaintenanceModel:StaffMaintenanceModel = StaffMaintenanceModel.getInstance(); 
		
		private var attorneyModel:AttorneyModel = AttorneyModel.getInstance(); 
		
		public function PersonController()
		{
		}
		
		public static function getInstance():PersonController
		{
			if(!_instance)
			{
				_instance = new PersonController();
			}
			
			return _instance; 
		}
		
		public function createStaff(staff:Object):void
		{
			var asyncToken:AsyncToken = serviceLocator.peopleRemoteObject.createStaff(serviceModel.appKey,
																					  serviceModel.clientIP,
																					  serviceModel.sessionID,  
																					  staff);
			asyncToken.staff = staff; 
			asyncToken.addResponder(new Responder(createStaffResult,faultHandlerResult));
		}
		
		private function createStaffResult(event:ResultEvent):void
		{
			if (event.result.SUCCESS == '1')
			{
				getStaffPerson(event.result.NEWSTAFFID);
				eventModel.dispatchEvent(new StaffMaintenanceEvent(StaffMaintenanceEvent.STAFF_CREATED)); 
			} else {
				ApplicationModel.APIError(event, 'Create Staff Error'); 
			}
		}
		
		public function findPerson(searchText:String):void
		{
			var asyncToken:AsyncToken = serviceLocator.peopleRemoteObject.findPerson(serviceModel.appKey,serviceModel.clientIP,searchText);
			asyncToken.addResponder(new Responder(findPersonResult,faultHandlerResult));
		}
		
		private function findPersonResult(event:ResultEvent):void
		{
			if (event.result.SUCCESS == '1')
			{
				personModel.searchResults = event.result.payload1;
				
				if(event.result.REAUTHSECONDS)
				{
					eventModel.dispatchEvent(new SessionEvent(SessionEvent.SECONDS_LEFT_UPDATE,parseInt(event.result.REAUTHSECONDS)));
				} 
			} else {
				var msgString:String = event.result.MESSAGE.MESSAGEUSER; 
				Alert.show(msgString.replace(/\|/g,'\n'),'Sorry');
			}
		}
    }

}    