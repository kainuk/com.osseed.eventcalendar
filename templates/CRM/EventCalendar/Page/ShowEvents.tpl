<div class='fc-toolbar fc-header-toolbar'>
{if $eventTypes == TRUE}
  <select id="event_selector" class="crm-form-select crm-select2 crm-action-menu fa-plu fc-left">
    <option value="all">{ts}All{/ts}</option>
    {foreach from=$eventTypes item=type}
         <option value="{$type}">{$type}</option>
    {/foreach}
  </select>
{/if}
  <div class="event-title-search fc-right" id="civievents-calendar-titles">
    <label>Title</label>
    <input id="event_title" type="text" name="event_title"/>
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
        debugger;
        show = show && (event.title.toLowerCase().includes(selectedTitle.toLowerCase()));
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
  });
}
</script>
{/literal}
