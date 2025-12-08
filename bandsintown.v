module bandsintown

import json
import net.http

// https://app.swaggerhub.com/apis-docs/Bandsintown/PublicAPI/3.0.1
const base_url = 'rest.bandsintown.com'
const date_upcoming = 'upcoming'
const date_past = 'past'
const date_all = 'all'
const special_character_escapes = {
	'/': '%252F'
	'?': '%253F'
	'*': '%252A'
	'"': '%27C'
}

pub struct ArtistData {
pub:
	id                   i32
	name                 string
	url                  string
	image_url            string
	thumb_url            string
	facebook_page_url    string
	mbid                 string
	tracker_count        i32
	upcoming_event_count i32
}

pub struct VenueData {
pub:
	name      string
	latitude  string
	longitude string
	city      string
	region    string
	country   string
}

pub struct OfferData {
pub:
	type   string
	url    string
	status string
}

pub struct EventData {
pub:
	id               string
	artist_id        string
	url              string
	on_sale_datetime string
	datetime         string
	description      string
	title            string
	venue            VenueData
	offers           []OfferData
	lineup           []string
}

pub struct Client {
	api_key string
}

pub fn new_client(api_key string) &Client {
	return &Client{
		api_key: api_key
	}
}

fn perform_request(url string) !http.Response {
	mut request := http.new_request(http.Method.get, url, '')
	response := request.do()!
	if response.status_code != 200 {
		return error(response.body)
	}
	return response
}

fn escape_special_characters(artist_name string) string {
	mut res := artist_name
	for old, new in special_character_escapes {
		res = artist_name.replace(old, new)
	}
	return res
}

fn build_url_artist_by_name(artist_name string, api_key string) string {
	escaped := escape_special_characters(artist_name)
	return 'https://${base_url}/artists/${escaped}?app_id=${api_key}'
}

fn build_url_artist_by_id(artist_id string, api_key string) string {
	return 'https://${base_url}/artists/id_${artist_id}?app_id=${api_key}'
}

fn build_url_events(artist_name string, date string, api_key string) string {
	return 'https://${base_url}/artists/${artist_name}/events?app_id=${api_key}&date=${date}'
}

pub fn (c Client) get_artist_by_name(artist_name string) !ArtistData {
	response := perform_request(build_url_artist_by_name(artist_name, c.api_key))!
	return json.decode(ArtistData, response.body)!
}

pub fn (c Client) get_artist_by_id(artist_id string) !ArtistData {
	response := perform_request(build_url_artist_by_id(artist_id, c.api_key))!
	return json.decode(ArtistData, response.body)!
}

fn (c Client) get_event_data(artist_name string, date string) ![]EventData {
	response := perform_request(build_url_events(artist_name, date, c.api_key))!
	return json.decode([]EventData, response.body)!
}

pub fn (c Client) get_event_data_upcoming(artist_name string) ![]EventData {
	return c.get_event_data(artist_name, date_upcoming)
}

pub fn (c Client) get_event_data_past(artist_name string) ![]EventData {
	return c.get_event_data(artist_name, date_past)
}

pub fn (c Client) get_event_data_all(artist_name string) ![]EventData {
	return c.get_event_data(artist_name, date_all)
}

pub fn (c Client) get_event_data_in_date_range(artist_name string, date_range string) ![]EventData {
	return c.get_event_data(artist_name, date_range)
}
