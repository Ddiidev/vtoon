
import vtoon

const key_value_toon = r'
id: 1
name: André🔥
age_person: 28
active: true
'

pub struct ValueToon {
	id         int
	name       string
	age_person int
	active     bool
}

fn test_key_value_toon() {
	value := vtoon.decode[ValueToon](key_value_toon)
	assert value.id == 1
	assert value.name == 'André🔥'
	assert value.age_person == 28
	assert value.active == true
}
