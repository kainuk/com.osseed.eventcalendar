<div class='fc-toolbar fc-header-toolbar'>
{if $eventTypes == TRUE}
  <div class=" fc-left">
  <label>{ts}Event Type{/ts}</label>
  <select id="event_selector" class="crm-form-select crm-select2 crm-action-menu fa-plu">
    <option value="all">{ts}All{/ts}</option>
    {foreach from=$eventTypes item=type}
         <option value="{$type}">{$type}</option>
    {/foreach}
  </select>
  </div>
{/if}
  <div class="fc-center">
  <label for="event_room">{ts}Zaal{/ts}</label>
  <select class="crm-form-select crm-select2 crm-action-menu" id="event_room" multiple="multiple">
      <option value="all">{ts}All{/ts}</option>
      {foreach from=$rooms key=key item=room}
        <option value="{$key}">{$room}</option>
      {/foreach}
  </select>
  </div>
  <div class="event-title-search fc-right" id="civievents-calendar-titles">
    <label>{ts}Title{/ts}</label>
    <input id="event_title" class="crm-form-text" type="text" name="event_title"/>
  </div>
  </div>
  <div class="fc-clear"></div>

</div>

<div id="calendar"></div>
{literal}
<script type="text/javascript">
  if (typeof(jQuery) != 'function'){
    var jQuery = cj;
  }
  else {
    var cj = jQuery;
  }

  cj( function( ) {
    checkFullCalendarLIbrary()
    .then(function() {
      buildCalendar();
    })
    .catch(function() {
      alert('Error loading calendar, try refreshing...');
    });
  });

/*
 * Checks if full calendar API is ready.
 *
 * @returns {Promise}
 *  if library is available or not.
 */
function checkFullCalendarLIbrary() {
  return new Promise((resolve, reject) => {
    if(cj.fullCalendar) {
      resolve();
    } else {
      cj(document).ajaxComplete(function() {
        if(cj.fullCalendar) {
          resolve();
        } else {
          reject();
        }
      });
    }
  });
}

function buildCalendar( ) {
  var events_data = {/literal}{$civicrm_events}{literal};
  var jsonStr = JSON.stringify(events_data);
  var showTime = events_data.timeDisplay;
  var weekStartDay = {/literal}{$weekBeginDay}{literal};

  cj('#calendar').fullCalendar({
    eventSources: [
      { events: events_data.events,}
    ],
    displayEventEnd: true,
    displayEventTime: showTime ? 1 : 0,
    firstDay:weekStartDay,
    timeFormat: 'H:mm',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },

    eventRender: function eventRender( event, element, view ) {
      element.append(event.location);
      show = false;
      if(event.eventType && events_data.isfilter == "1" ) {
        show = ['all', event.eventType].indexOf(cj('#event_selector').val()) >= 0
      }
      selectedTitle = cj('#event_title').val();
      if(selectedTitle.length>0){
        show = show && (event.title.toLowerCase().includes(selectedTitle.toLowerCase()));
      }
      eventRoom = cj('#event_room').val();
      if(eventRoom!=='all'){
        debugger;
        show = show && Object.values(event.rooms).includes(eventRoom);
      }
      return show;
    }
  });

  CRM.$(function($) {
    $("#event_selector").change(function() {
      cj('#calendar').fullCalendar('rerenderEvents');
    });
    $("#event_title").on("input",function() {
      cj('#calendar').fullCalendar('rerenderEvents');
    });
    $("#event_room").on("input",function() {
      cj('#calendar').fullCalendar('rerenderEvents');
    });
  });
}
</script>
{/literal}
