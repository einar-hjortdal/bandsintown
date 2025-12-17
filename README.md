<span style="background-color: #fed766; color: #0a080c; font-size: 125%; padding-top: 1.25%; padding-right: 2.5%; padding-bottom: 1.25%; padding-left: 2.5%; border-radius: 25px;">This project is stable: bugs are being fixed.</span>

# bandsintown

Client for the bandsintown API

## Usage

Install with `v install einar-hjortdal.bandsintown`

```V
import einar_hjortdal.bandsintown

bandsintown_client := bandsintown.new_client(os.getenv('API_KEY'))
// use the public methods on bandsintown.Client
```
