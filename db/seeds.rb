# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Site.delete_all
sites = [
  { pxe: '10.5.1.65', storage: '10.5.1.65', code: 5,  abbr: 'do', name: 'District Office'         },
  { pxe: '10.10.1.2', storage: '10.10.1.2', code: 10, abbr: 'cc', name: 'Cedarcreek School'       },
  { pxe: '10.15.1.2', storage: '10.15.1.2', code: 15, abbr: 'em', name: 'Emblem School'           },
  { pxe: '10.20.1.2', storage: '10.20.1.2', code: 20, abbr: 'hi', name: 'Highlands School'        },
  { pxe: '10.25.1.2', storage: '10.25.1.2', code: 25, abbr: 'mv', name: 'Mountainview School'     },
  { pxe: '10.30.1.2', storage: '10.30.1.2', code: 30, abbr: 'rv', name: 'Rio Vista School'        },
  { pxe: '10.35.1.2', storage: '10.35.1.2', code: 35, abbr: 'ro', name: 'Rosedell School'         },
  { pxe: '10.40.1.2', storage: '10.40.1.2', code: 40, abbr: 'sc', name: 'Santa Clarita School'    },
  { pxe: '10.45.1.2', storage: '10.45.1.2', code: 45, abbr: 'he', name: 'Charles Helmers School'  },
  { pxe: '10.50.1.2', storage: '10.50.1.2', code: 50, abbr: 'sk', name: 'Skyblue Mesa School'     },
  { pxe: '10.55.1.2', storage: '10.55.1.2', code: 55, abbr: 'fo', name: 'James Foster School'     },
  { pxe: '10.60.1.2', storage: '10.60.1.2', code: 60, abbr: 'bo', name: 'Bouquet Canyon School'   },
  { pxe: '10.65.1.2', storage: '10.65.1.2', code: 65, abbr: 'pc', name: 'Plum Canyon School'      },
  { pxe: '10.70.1.2', storage: '10.70.1.2', code: 70, abbr: 'np', name: 'North Park School'       },
  { pxe: '10.75.1.2', storage: '10.75.1.2', code: 75, abbr: 'bp', name: 'Bridgeport School'       },
  { pxe: '10.80.1.2', storage: '10.80.1.2', code: 80, abbr: 'tv', name: 'Tesoro Del Valle School' },
  { pxe: '10.85.1.2', storage: '10.85.1.2', code: 85, abbr: 'wc', name: 'West Creek Academy'      }
  ]
  
sites.each do |site|
  Site.create(site)
end