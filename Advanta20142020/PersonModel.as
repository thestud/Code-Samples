package com.advanta.models
{
	
	import flash.net.SharedObject;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class PersonModel
	{
		private static var _instance:PersonModel; 
		
		 
		public var addressPrimary:Object; 
		
		public var availPanelListFSO:SharedObject;
		
		public var emailPrimary:Object; 
		
		public var isStateBarStatus:Boolean = false; 
		
		public var mcles:ArrayCollection = new ArrayCollection();
		
		public var members:ArrayCollection = new ArrayCollection(); 
		
		// for person management
		public var names:ArrayCollection = new ArrayCollection(); 
		
		public var phonePrimary:Object;  
		
		public var searchResults:ArrayCollection = new ArrayCollection(); 
		
		public var stateBarNumber:Number; 
		
		
		
		public function PersonModel()
		{
			
		}
		
		public function clear():void
		{
			addressPrimary = null; 
			emailPrimary = null; 
			isStateBarStatus = false; 
			names = new ArrayCollection(); 
			phonePrimary = null; 
			AttorneyModel.getInstance().person = null; 
			AttorneyModel.getInstance().personIds = null; 
			AttorneyModel.getInstance().applications = null; 
			EvaluationsModel.getInstance().clear(); 
			if(mcles)mcles.removeAll(); 
			searchResults = new ArrayCollection(); 
			AttorneyModel.getInstance().addresses.removeAll();
			AttorneyModel.getInstance().phones.removeAll();
			AttorneyModel.getInstance().emails.removeAll(); 
		}
		
		public static function getInstance():PersonModel
		{
			if(!_instance)
			{
				_instance = new PersonModel();
			}
			return _instance;
		}
		
	}
}