# bandsintown

Client for the bandsintown API

## Usage

Install with `v install einar-hjortdal.bandsintown`

```V
import einar_hjortdal.bandsintown

bandsintown_client := bandsintown.new_client(os.getenv('API_KEY'))
// use the public methods on bandsintown.Client
```
