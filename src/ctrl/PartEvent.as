/*
 * FIRC: A IRC Client for Flash Player 9 and above
 * Copyright (C) 2005-2006 Darron Schall <darron@darronschall.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
 * 02111-1307 USA
 */
package ctrl 
{

import flash.events.Event;

/**
 * A ConnectEvent is used to signal that an IRC connection
 * needs to be made to a specific host on a specific port.
 */
public class PartEvent extends Event
{
	/** Static constant for the event type to avoid typos with strings */
	public static const PART_EVENT_TYPE:String = "partEvent";

	/** The port over which to contact the host */
	private var mchanId:String;
	
	/** The port over which to contact the host */
	private var mReason:String;
	
	/**
	 * Constructor, create a new ConnectEvent with a specific host and port
	 */
	public function PartEvent( chanId:String = "", reason:String= "Bye")
	{
		super( PART_EVENT_TYPE );
		
		this.mchanId = chanId;
		this.mReason = reason;
	}
	
	public function get ChanId():String {
		return mchanId;
	}
	
	public function get Reason():String {
		return mReason;
	}

} // end class
} // end package