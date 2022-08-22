 export function wait(ms) {
    return () => new Promise(resolve => {
      setTimeout(resolve, ms)
    })
  }

  export function keepAlive(seconds = 60) {
    fetch('/keep-alive')
      .then(wait(seconds * 1000 /*ms*/))
      .then(keepAlive)
  }

  export function localize_time(utc_time, locales = []){
    const client_timezone = Intl.DateTimeFormat().resolvedOptions().timeZone

    const options = {
      timeZone: client_timezone,
      year: 'numeric', month: 'numeric', day: 'numeric',
      hour: 'numeric', minute: 'numeric', second: 'numeric'
      };
  
    const formatter = new Intl.DateTimeFormat(locales, options);

    return formatter.format(new Date(utc_time));
  }
  