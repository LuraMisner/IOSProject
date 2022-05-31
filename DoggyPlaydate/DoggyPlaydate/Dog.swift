//
//  Dog.swift
//  DoggyPlaydate
//
//  Created by Shauna Kimura on 10/21/21.
//  Edited by Jackson Hall on 12/04/21
//

import Foundation
import FirebaseFirestoreSwift

extension Dog: FirestoreStorable {}
extension Dog: Equatable {

    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.id == rhs.id
    }
}

final class Dog {
        
    static var COLLECTION_NAME = "DogsTest"
    static var ID_PREFIX = "dog"

    // Must initialize with default values to allow asynchronous init() calls
    var id: String
    var name: String
    var ownersIds: [String] = []
    var breed: Breed = Breed.unspecified
    var sex: Sex = Sex.unspecified
    var favoriteToy: String = "Unknown"
    var age: Age = Age.unspecified
    
    init(id: String,
         name: String,
         ownersIds: [String],
         breed: Breed,
         sex: Sex,
         favoriteToy: String,
         age: Age) {
        Dog.isUniqueId(id: id) { isUnique in
            if !isUnique {
                print("Warning: Initializing \(Self.typeName) with existing ID \"\(id)\"")
            }
        }
        
        self.id = id
        self.name = name
        self.ownersIds = ownersIds
        self.breed = breed
        self.sex = sex
        self.favoriteToy = favoriteToy
        self.age = age
        
        // Add to Firestore
        Dog.writeDocument(obj: self) { successful in
            if !successful {
                print("Warning: Failed writing \(Self.typeName) with ID \"\(self.id)\" in init()")
            }
        }
    }
    
    // Initialize with default fields
    static func defaultInit(completion: @escaping (Dog) -> Void) {
        Dog.getNewUniqueId() { newId in
            OperationQueue.main.addOperation {
                let dog = Dog(id: newId,
                              name: "Unspecified",
                              ownersIds: [],
                              breed: Breed.unspecified,
                              sex: Sex.unspecified,
                              favoriteToy: "Unspecified",
                              age: Age.unspecified)
                completion(dog)
            }
        }
    }
    
    // Return an array of Users, the `dog`'s owners, pulled from Firestore, ignoring nil results
    static func getOwners(dog: Dog, completion: @escaping ([User]) -> Void) {
        
        if VERBOSE {
            print("test: Dog.getOwner() called")
        }
        
        User.fetchDocuments(ids: dog.ownersIds) { users in
            OperationQueue.main.addOperation {
                completion(users.compactMap { $0 } )
            }
        }
    }
    
    // Establish `owner`'s ownership of `self` 
    func addOwner(owner: User, completion: @escaping (Bool) -> Void) {
        
        if VERBOSE {
            print("test: Dog.addOwner(owner:) called")
        }
        
        // Check if Dog ID should be appended to User's owned Dog list
        if !self.ownersIds.contains(owner.id) {
            self.ownersIds.append(owner.id)
        }
        
        // Check if User ID should be appended to Dog's owner list
        if !owner.dogsIds.contains(self.id) {
            owner.dogsIds.append(self.id)
        }
        
        var funcSuccessful = false
        Dog.deleteDocument(id: self.id) { _ in
            Dog.writeDocument(obj: self) { successful in
                if !successful {
                    print("Warning: failed writing Dog with ID \"\(self.id)\" from Dog.addOwner()")
                    funcSuccessful = false
                }
                User.deleteDocument(id: owner.id) { _ in
                    User.writeDocument(obj: owner) { successful in
                        if !successful {
                            print("Warning: failed writing User with ID \"\(owner.id)\" from Dog.addOwner()")
                            funcSuccessful = false
                        }
                        
                        OperationQueue.main.addOperation {
                            completion(funcSuccessful)
                        }
                    }
                }
            }
        }
    }
    
    enum Age: String, Codable {
        case puppy = "Puppy"
        case adolescent = "Adolescent"
        case adult = "Adult"
        case senior = "Senior"
        case unspecified = "Unspecified"
    }
    
    enum Sex: String, Codable {
        case male = "Male"
        case female = "Female"
        case unspecified = "Unspecified"
    }
    
    enum Breed: String, Codable {
        case unspecified = "Unspecified"
        case affenpinscher = "Affenpinscher"
        case afghan_hound = "Afghan Hound"
        case africanis = "Africanis"
        case aidi = "Aidi"
        case airedale_terrier = "Airedale Terrier"
        case akbash = "Akbash"
        case akita = "Akita"
        case aksaray_malaklisi = "Aksaray Malaklisi"
        case alano_español = "Alano Español"
        case alapaha_blue_blood_bulldog = "Alapaha Blue Blood Bulldog"
        case alaskan_husky = "Alaskan husky"
        case alaskan_klee_kai = "Alaskan Klee Kai"
        case alaskan_malamute = "Alaskan Malamute"
        case alopekis = "Alopekis"
        case alpine_dachsbracke = "Alpine Dachsbracke"
        case american_bulldog = "American Bulldog"
        case american_bully = "American Bully"
        case american_cocker_spaniel = "American Cocker Spaniel"
        case american_english_coonhound = "American English Coonhound"
        case american_eskimo_dog = "American Eskimo Dog"
        case american_foxhound = "American Foxhound"
        case american_hairless_terrier = "American Hairless Terrier"
        case american_pit_bull_terrier = "American Pit Bull Terrier"
        case american_staffordshire_terrier = "American Staffordshire Terrier"
        case american_water_spaniel = "American Water Spaniel"
        case andalusian_hound = "Andalusian Hound"
        case anglo_français_de_petite_vénerie = "Anglo-Français de Petite Vénerie"
        case appenzeller_sennenhund = "Appenzeller Sennenhund"
        case ariegeois = "Ariegeois"
        case armant = "Armant"
        case armenian_gampr_dog = "Armenian Gampr dog"
        case artois_hound = "Artois Hound"
        case australian_cattle_dog = "Australian Cattle Dog"
        case australian_kelpie = "Australian Kelpie"
        case australian_shepherd = "Australian Shepherd"
        case australian_stumpy_tail_cattle_dog = "Australian Stumpy Tail Cattle Dog"
        case australian_terrier = "Australian Terrier"
        case austrian_black_and_tan_hound = "Austrian Black and Tan Hound"
        case austrian_pinscher = "Austrian Pinscher"
        case azawakh = "Azawakh"
        case bakharwal_dog = "Bakharwal dog"
        case banjara_hound = "Banjara Hound"
        case barbado_da_terceira = "Barbado da Terceira"
        case barbet = "Barbet"
        case basenji = "Basenji"
        case basque_shepherd_dog = "Basque Shepherd Dog"
        case basset_artésien_normand = "Basset Artésien Normand"
        case basset_bleu_de_gascogne = "Basset Bleu de Gascogne"
        case basset_fauve_de_bretagne = "Basset Fauve de Bretagne"
        case basset_hound = "Basset Hound"
        case bavarian_mountain_hound = "Bavarian Mountain Hound"
        case beagle = "Beagle"
        case beagle_harrier = "Beagle-Harrier"
        case belgian_shepherd = "Belgian Shepherd"
        case bearded_collie = "Bearded Collie"
        case beauceron = "Beauceron"
        case bedlington_terrier = "Bedlington Terrier"
        case bergamasco_shepherd = "Bergamasco Shepherd"
        case berger_picard = "Berger Picard"
        case bernese_mountain_dog = "Bernese Mountain Dog"
        case bichon_frisé = "Bichon Frisé"
        case billy = "Billy"
        case black_and_tan_coonhound = "Black and Tan Coonhound"
        case black_norwegian_elkhound = "Black Norwegian Elkhound"
        case black_russian_terrier = "Black Russian Terrier"
        case black_mouth_cur = "Black Mouth Cur"
        case bloodhound = "Bloodhound"
        case blue_lacy = "Blue Lacy"
        case blue_picardy_spaniel = "Blue Picardy Spaniel"
        case bluetick_coonhound = "Bluetick Coonhound"
        case boerboel = "Boerboel"
        case bohemian_shepherd = "Bohemian Shepherd"
        case bolognese = "Bolognese"
        case border_collie = "Border Collie"
        case border_terrier = "Border Terrier"
        case borzoi = "Borzoi"
        case bosnian_coarse_haired_hound = "Bosnian Coarse-haired Hound"
        case boston_terrier = "Boston Terrier"
        case bouvier_des_ardennes = "Bouvier des Ardennes"
        case bouvier_des_flandres = "Bouvier des Flandres"
        case boxer = "Boxer"
        case boykin_spaniel = "Boykin Spaniel"
        case bracco_italiano = "Bracco Italiano"
        case braque_d_auvergne = "Braque d'Auvergne"
        case braque_de_l_ariège = "Braque de l'Ariège"
        case braque_du_bourbonnais = "Braque du Bourbonnais"
        case braque_francais = "Braque Francais"
        case braque_saint_germain = "Braque Saint-Germain"
        case briard = "Briard"
        case briquet_griffon_vendéen = "Briquet Griffon Vendéen"
        case brittany = "Brittany"
        case broholmer = "Broholmer"
        case bruno_jura_hound = "Bruno Jura Hound"
        case brussels_griffon = "Brussels Griffon"
        case bucovina_shepherd_dog = "Bucovina Shepherd Dog"
        case bull_arab = "Bull Arab"
        case bull_terrier = "Bull Terrier"
        case bulldog = "Bulldog"
        case bullmastiff = "Bullmastiff"
        case bully_kutta = "Bully Kutta"
        case burgos_pointer = "Burgos Pointer"
        case ca_mè_mallorquí = "Ca Mè Mallorquí"
        case cairn_terrier = "Cairn Terrier"
        case campeiro_bulldog = "Campeiro Bulldog"
        case can_de_chira = "Can de Chira"
        case can_de_palleiro = "Can de Palleiro"
        case canaan_dog = "Canaan Dog"
        case canadian_eskimo_dog = "Canadian Eskimo Dog"
        case cane_corso = "Cane Corso"
        case cane_di_oropa = "Cane di Oropa"
        case cane_paratore = "Cane Paratore"
        case cantabrian_water_dog = "Cantabrian Water Dog"
        case cão_da_serra_de_aires = "Cão da Serra de Aires"
        case cão_de_castro_laboreiro = "Cão de Castro Laboreiro"
        case cão_de_gado_transmontano = "Cão de Gado Transmontano"
        case cão_fila_de_são_miguel = "Cão Fila de São Miguel"
        case cardigan_welsh_corgi = "Cardigan Welsh Corgi"
        case carea_castellano_manchego = "Carea Castellano Manchego"
        case carea_leonés = "Carea Leonés"
        case carolina_dog = "Carolina Dog"
        case carpathian_shepherd_dog = "Carpathian Shepherd Dog"
        case catahoula_leopard_dog = "Catahoula Leopard Dog"
        case catalan_sheepdog = "Catalan Sheepdog"
        case caucasian_shepherd_dog = "Caucasian Shepherd Dog"
        case cavalier_king_charles_spaniel = "Cavalier King Charles Spaniel"
        case central_asian_shepherd_dog = "Central Asian Shepherd Dog"
        case cesky_fousek = "Cesky Fousek"
        case cesky_terrier = "Cesky Terrier"
        case chesapeake_bay_retriever = "Chesapeake Bay Retriever"
        case chien_français_blanc_et_noir = "Chien Français Blanc et Noir"
        case chien_français_blanc_et_orange = "Chien Français Blanc et Orange"
        case chien_français_tricolore = "Chien Français Tricolore"
        case chihuahua = "Chihuahua"
        case chilean_terrier = "Chilean Terrier"
        case chinese_crested_dog = "Chinese Crested Dog"
        case chinook = "Chinook"
        case chippiparai = "Chippiparai"
        case chongqing_dog = "Chongqing dog"
        case chortai = "Chortai"
        case chow_chow = "Chow Chow"
        case cimarrón_uruguayo = "Cimarrón Uruguayo"
        case cirneco_dell_etna = "Cirneco dell'Etna"
        case clumber_spaniel = "Clumber Spaniel"
        case colombian_fino_hound = "Colombian fino hound"
        case coton_de_tulear = "Coton de Tulear"
        case cretan_hound = "Cretan Hound"
        case croatian_sheepdog = "Croatian Sheepdog"
        case curly_coated_retriever = "Curly-Coated Retriever"
        case cursinu = "Cursinu"
        case czechoslovakian_wolfdog = "Czechoslovakian Wolfdog"
        case dachshund = "Dachshund"
        case dalmatian = "Dalmatian"
        case dandie_dinmont_terrier = "Dandie Dinmont Terrier"
        case danish_spitz = "Danish Spitz"
        case danish_swedish_farmdog = "Danish-Swedish Farmdog"
        case denmark_feist = "Denmark Feist"
        case dingo = "Dingo "
        case dobermann = "Dobermann"
        case dogo_argentino = "Dogo Argentino"
        case dogo_guatemalteco = "Dogo Guatemalteco"
        case dogo_sardesco = "Dogo Sardesco"
        case dogue_brasileiro = "Dogue Brasileiro"
        case dogue_de_bordeaux = "Dogue de Bordeaux"
        case drentse_patrijshond = "Drentse Patrijshond"
        case drever = "Drever"
        case dunker = "Dunker"
        case dutch_shepherd = "Dutch Shepherd"
        case dutch_smoushond = "Dutch Smoushond"
        case east_siberian_laika = "East Siberian Laika"
        case east_european_shepherd = "East European Shepherd"
        case ecuadorian_hairless_dog = "Ecuadorian Hairless Dog"
        case english_cocker_spaniel = "English Cocker Spaniel"
        case english_foxhound = "English Foxhound"
        case english_mastiff = "English Mastiff"
        case english_setter = "English Setter"
        case english_shepherd = "English Shepherd"
        case english_springer_spaniel = "English Springer Spaniel"
        case english_toy_terrier = "English Toy Terrier"
        case entlebucher_mountain_dog = "Entlebucher Mountain Dog"
        case estonian_hound = "Estonian Hound"
        case estrela_mountain_dog = "Estrela Mountain Dog"
        case eurasier = "Eurasier"
        case field_spaniel = "Field Spaniel"
        case fila_brasileiro = "Fila Brasileiro"
        case finnish_hound = "Finnish Hound"
        case finnish_lapphund = "Finnish Lapphund"
        case finnish_spitz = "Finnish Spitz"
        case flat_coated_retriever = "Flat-Coated Retriever"
        case french_bulldog = "French Bulldog"
        case french_spaniel = "French Spaniel"
        case galgo_español = "Galgo Español"
        case garafian_shepherd = "Garafian Shepherd"
        case gascon_saintongeois = "Gascon Saintongeois"
        case georgian_shepherd = "Georgian Shepherd"
        case german_hound = "German Hound"
        case german_longhaired_pointer = "German Longhaired Pointer"
        case german_pinscher = "German Pinscher"
        case german_roughhaired_pointer = "German Roughhaired Pointer"
        case german_shepherd_dog = "German Shepherd Dog"
        case german_shorthaired_pointer = "German Shorthaired Pointer"
        case german_spaniel = "German Spaniel"
        case german_spitz = "German Spitz"
        case german_wirehaired_pointer = "German Wirehaired Pointer"
        case giant_schnauzer = "Giant Schnauzer"
        case glen_of_imaal_terrier = "Glen of Imaal Terrier"
        case golden_retriever = "Golden Retriever"
        case gończy_polski = "Gończy Polski"
        case gordon_setter = "Gordon Setter"
        case grand_anglo_français_blanc_et_noir = "Grand Anglo-Français Blanc et Noir"
        case grand_anglo_français_blanc_et_orange = "Grand Anglo-Français Blanc et Orange"
        case grand_anglo_français_tricolore = "Grand Anglo-Français Tricolore"
        case grand_basset_griffon_vendéen = "Grand Basset Griffon Vendéen"
        case grand_bleu_de_gascogne = "Grand Bleu de Gascogne"
        case grand_griffon_vendéen = "Grand Griffon Vendéen"
        case great_dane = "Great Dane"
        case greater_swiss_mountain_dog = "Greater Swiss Mountain Dog"
        case greek_harehound = "Greek Harehound"
        case greek_shepherd = "Greek Shepherd"
        case greenland_dog = "Greenland Dog"
        case greyhound = "Greyhound"
        case griffon_bleu_de_gascogne = "Griffon Bleu de Gascogne"
        case griffon_fauve_de_bretagne = "Griffon Fauve de Bretagne"
        case griffon_nivernais = "Griffon Nivernais"
        case gull_dong = "Gull Dong"
        case gull_terrier = "Gull Terrier"
        case hällefors_elkhound = "Hällefors Elkhound"
        case halden_hound = "Halden Hound"
        case hamiltonstövare = "Hamiltonstövare"
        case hanover_hound = "Hanover Hound"
        case harrier = "Harrier"
        case havanese = "Havanese"
        case himalayan_sheepdog = "Himalayan Sheepdog"
        case hierran_wolfdog = "Hierran Wolfdog"
        case hokkaido = "Hokkaido"
        case hovawart = "Hovawart"
        case huntaway = "Huntaway"
        case hygen_hound = "Hygen Hound"
        case ibizan_hound = "Ibizan Hound"
        case icelandic_sheepdog = "Icelandic Sheepdog"
        case indian_pariah_dog = "Indian pariah dog"
        case indian_spitz = "Indian Spitz"
        case irish_red_and_white_setter = "Irish Red and White Setter"
        case irish_setter = "Irish Setter"
        case irish_terrier = "Irish Terrier"
        case irish_water_spaniel = "Irish Water Spaniel"
        case irish_wolfhound = "Irish Wolfhound"
        case istrian_coarse_haired_hound = "Istrian Coarse-haired Hound"
        case istrian_shorthaired_hound = "Istrian Shorthaired Hound"
        case italian_greyhound = "Italian Greyhound"
        case jack_russell_terrier = "Jack Russell Terrier"
        case jagdterrier = "Jagdterrier"
        case japanese_chin = "Japanese Chin"
        case japanese_spitz = "Japanese Spitz"
        case japanese_terrier = "Japanese Terrier"
        case jindo = "Jindo"
        case jonangi = "Jonangi"
        case kai_ken = "Kai Ken"
        case kaikadi = "Kaikadi"
        case kangal_shepherd_dog = "Kangal Shepherd Dog"
        case kanni = "Kanni"
        case karakachan_dog = "Karakachan dog"
        case karelian_bear_dog = "Karelian Bear Dog"
        case kars = "Kars"
        case karst_shepherd = "Karst Shepherd"
        case keeshond = "Keeshond"
        case kerry_beagle = "Kerry Beagle"
        case kerry_blue_terrier = "Kerry Blue Terrier"
        case khala = "Khala"
        case king_charles_spaniel = "King Charles Spaniel"
        case king_shepherd = "King Shepherd"
        case kintamani = "Kintamani"
        case kishu = "Kishu"
        case kokoni = "Kokoni"
        case kombai = "Kombai"
        case komondor = "Komondor"
        case kooikerhondje = "Kooikerhondje"
        case koolie = "Koolie"
        case koyun_dog = "Koyun dog"
        case kromfohrländer = "Kromfohrländer"
        case kuchi = "Kuchi"
        case kuvasz = "Kuvasz"
        case labrador_retriever = "Labrador Retriever"
        case lagotto_romagnolo = "Lagotto Romagnolo"
        case lakeland_terrier = "Lakeland Terrier"
        case lancashire_heeler = "Lancashire Heeler"
        case landseer = "Landseer"
        case lapponian_herder = "Lapponian Herder"
        case large_münsterländer = "Large Münsterländer"
        case leonberger = "Leonberger"
        case levriero_sardo = "Levriero Sardo"
        case lhasa_apso = "Lhasa Apso"
        case lithuanian_hound = "Lithuanian Hound"
        case löwchen = "Löwchen"
        case lupo_italiano = "Lupo Italiano"
        case mackenzie_river_husky = "Mackenzie River husky"
        case magyar_agár = "Magyar agár"
        case mahratta_greyhound = "Mahratta Greyhound"
        case maltese = "Maltese"
        case manchester_terrier = "Manchester Terrier"
        case maremmano_abruzzese_sheepdog = "Maremmano-Abruzzese Sheepdog"
        case mcnab_dog = "McNab dog"
        case miniature_american_shepherd = "Miniature American Shepherd"
        case miniature_bull_terrier = "Miniature Bull Terrier"
        case miniature_fox_terrier = "Miniature Fox Terrier"
        case miniature_pinscher = "Miniature Pinscher"
        case miniature_schnauzer = "Miniature Schnauzer"
        case molossus_of_epirus = "Molossus of Epirus"
        case montenegrin_mountain_hound = "Montenegrin Mountain Hound"
        case mountain_cur = "Mountain Cur"
        case mountain_feist = "Mountain Feist"
        case mucuchies = "Mucuchies"
        case mudhol_hound = "Mudhol Hound"
        case mudi = "Mudi"
        case neapolitan_mastiff = "Neapolitan Mastiff"
        case new_guinea_singing_dog = "New Guinea singing dog"
        case new_zealand_heading_dog = "New Zealand Heading Dog"
        case newfoundland = "Newfoundland"
        case norfolk_terrier = "Norfolk Terrier"
        case norrbottenspets = "Norrbottenspets"
        case northern_inuit_dog = "Northern Inuit Dog"
        case norwegian_buhund = "Norwegian Buhund"
        case norwegian_elkhound = "Norwegian Elkhound"
        case norwegian_lundehund = "Norwegian Lundehund"
        case norwich_terrier = "Norwich Terrier"
        case nova_scotia_duck_tolling_retriever = "Nova Scotia Duck Tolling Retriever"
        case old_croatian_sighthound = "Old Croatian Sighthound"
        case old_danish_pointer = "Old Danish Pointer"
        case old_english_sheepdog = "Old English Sheepdog"
        case old_english_terrier = "Old English Terrier"
        case olde_english_bulldogge = "Olde English Bulldogge"
        case otterhound = "Otterhound"
        case pachon_navarro = "Pachon Navarro"
        case pampas_deerhound = "Pampas Deerhound"
        case paisley_terrier = "Paisley Terrier"
        case papillon = "Papillon"
        case parson_russell_terrier = "Parson Russell Terrier"
        case pastore_della_lessinia_e_del_lagorai = "Pastore della Lessinia e del Lagorai"
        case patagonian_sheepdog = "Patagonian Sheepdog"
        case patterdale_terrier = "Patterdale Terrier"
        case pekingese = "Pekingese"
        case pembroke_welsh_corgi = "Pembroke Welsh Corgi"
        case perro_majorero = "Perro Majorero"
        case perro_de_pastor_mallorquin = "Perro de Pastor Mallorquin"
        case perro_de_presa_canario = "Perro de Presa Canario"
        case perro_de_presa_mallorquin = "Perro de Presa Mallorquin"
        case peruvian_inca_orchid = "Peruvian Inca Orchid"
        case petit_basset_griffon_vendéen = "Petit Basset Griffon Vendéen"
        case petit_bleu_de_gascogne = "Petit Bleu de Gascogne"
        case phalène = "Phalène"
        case pharaoh_hound = "Pharaoh Hound"
        case phu_quoc_ridgeback = "Phu Quoc Ridgeback"
        case picardy_spaniel = "Picardy Spaniel"
        case plummer_terrier = "Plummer Terrier"
        case plott_hound = "Plott Hound"
        case podenco_canario = "Podenco Canario"
        case podenco_valenciano = "Podenco Valenciano"
        case pointer = "Pointer"
        case poitevin = "Poitevin"
        case polish_greyhound = "Polish Greyhound"
        case polish_hound = "Polish Hound"
        case polish_lowland_sheepdog = "Polish Lowland Sheepdog"
        case polish_tatra_sheepdog = "Polish Tatra Sheepdog"
        case pomeranian = "Pomeranian"
        case pont_audemer_spaniel = "Pont-Audemer Spaniel"
        case poodle = "Poodle"
        case porcelaine = "Porcelaine"
        case portuguese_podengo = "Portuguese Podengo"
        case portuguese_pointer = "Portuguese Pointer"
        case portuguese_water_dog = "Portuguese Water Dog"
        case posavac_hound = "Posavac Hound"
        case pražský_krysařík = "Pražský Krysařík"
        case pshdar_dog = "Pshdar dog"
        case pudelpointer = "Pudelpointer"
        case pug = "Pug"
        case puli = "Puli"
        case pumi = "Pumi"
        case pungsan_dog = "Pungsan dog"
        case pyrenean_mastiff = "Pyrenean Mastiff"
        case pyrenean_mountain_dog = "Pyrenean Mountain Dog"
        case pyrenean_sheepdog = "Pyrenean Sheepdog"
        case rafeiro_do_alentejo = "Rafeiro do Alentejo"
        case rajapalayam = "Rajapalayam"
        case rampur_greyhound = "Rampur Greyhound"
        case rat_terrier = "Rat Terrier"
        case ratonero_bodeguero_andaluz = "Ratonero Bodeguero Andaluz"
        case ratonero_mallorquin = "Ratonero Mallorquin"
        case ratonero_murciano = "Ratonero Murciano"
        case ratonero_valenciano = "Ratonero Valenciano"
        case redbone_coonhound = "Redbone Coonhound"
        case rhodesian_ridgeback = "Rhodesian Ridgeback"
        case romanian_mioritic_shepherd_dog = "Romanian Mioritic Shepherd Dog"
        case romanian_raven_shepherd_dog = "Romanian Raven Shepherd Dog"
        case rottweiler = "Rottweiler"
        case rough_collie = "Rough Collie"
        case russian_spaniel = "Russian Spaniel"
        case russian_toy = "Russian Toy"
        case russo_european_laika = "Russo-European Laika"
        case ryukyu_inu = "Ryukyu Inu"
        case saarloos_wolfdog = "Saarloos Wolfdog"
        case sabueso_español = "Sabueso Español"
        case saint_bernard = "Saint Bernard"
        case saint_hubert_jura_hound = "Saint Hubert Jura Hound"
        case saint_usuge_spaniel = "Saint-Usuge Spaniel"
        case saluki = "Saluki"
        case samoyed = "Samoyed"
        case sapsali = "Sapsali"
        case sarabi_dog = "Sarabi dog"
        case sardinian_shepherd_dog = "Sardinian Shepherd Dog"
        case šarplaninac = "Šarplaninac"
        case schapendoes = "Schapendoes"
        case schillerstövare = "Schillerstövare"
        case schipperke = "Schipperke"
        case schweizer_laufhund = "Schweizer Laufhund"
        case schweizerischer_niederlaufhund = "Schweizerischer Niederlaufhund"
        case scottish_deerhound = "Scottish Deerhound"
        case scottish_terrier = "Scottish Terrier"
        case sealyham_terrier = "Sealyham Terrier"
        case segugio_dell_appennino = "Segugio dell'Appennino"
        case segugio_italiano = "Segugio Italiano"
        case segugio_maremmano = "Segugio Maremmano"
        case serbian_hound = "Serbian Hound"
        case serbian_tricolour_hound = "Serbian Tricolour Hound"
        case serrano_bulldog = "Serrano Bulldog"
        case shar_pei = "Shar Pei"
        case shetland_sheepdog = "Shetland Sheepdog"
        case shiba_inu = "Shiba Inu"
        case shih_tzu = "Shih Tzu"
        case shikoku = "Shikoku"
        case shiloh_shepherd = "Shiloh Shepherd"
        case siberian_husky = "Siberian Husky"
        case silken_windhound = "Silken Windhound"
        case silky_terrier = "Silky Terrier"
        case sinhala_hound = "Sinhala Hound"
        case skye_terrier = "Skye Terrier"
        case sloughi = "Sloughi"
        case slovakian_wirehaired_pointer = "Slovakian Wirehaired Pointer"
        case slovenský_cuvac = "Slovenský Cuvac"
        case slovenský_kopov = "Slovenský Kopov"
        case smalandstövare = "Smalandstövare"
        case small_greek_domestic_dog = "Small Greek domestic dog"
        case small_münsterländer = "Small Münsterländer"
        case smooth_collie = "Smooth Collie"
        case smooth_fox_terrier = "Smooth Fox Terrier"
        case soft_coated_wheaten_terrier = "Soft-Coated Wheaten Terrier"
        case south_russian_ovcharka = "South Russian Ovcharka"
        case spanish_mastiff = "Spanish Mastiff"
        case spanish_water_dog = "Spanish Water Dog"
        case spinone_italiano = "Spinone Italiano"
        case sporting_lucas_terrier = "Sporting Lucas Terrier"
        case stabyhoun = "Stabyhoun"
        case staffordshire_bull_terrier = "Staffordshire Bull Terrier"
        case standard_schnauzer = "Standard Schnauzer"
        case stephens_stock = "Stephens Stock"
        case styrian_coarse_haired_hound = "Styrian Coarse-haired Hound"
        case sussex_spaniel = "Sussex Spaniel"
        case swedish_elkhound = "Swedish Elkhound"
        case swedish_lapphund = "Swedish Lapphund"
        case swedish_vallhund = "Swedish Vallhund"
        case swedish_white_elkhound = "Swedish White Elkhound"
        case taigan = "Taigan"
        case taiwan_dog = "Taiwan Dog"
        case tamaskan_dog = "Tamaskan Dog"
        case tazy = "Tazy"
        case teddy_roosevelt_terrier = "Teddy Roosevelt Terrier"
        case telomian = "Telomian"
        case tenterfield_terrier = "Tenterfield Terrier"
        case terrier_brasileiro = "Terrier Brasileiro"
        case thai_bangkaew_dog = "Thai Bangkaew Dog"
        case thai_ridgeback = "Thai Ridgeback"
        case tibetan_mastiff = "Tibetan Mastiff"
        case tibetan_spaniel = "Tibetan Spaniel"
        case tibetan_terrier = "Tibetan Terrier"
        case tornjak = "Tornjak"
        case tosa = "Tosa"
        case toy_fox_terrier = "Toy Fox Terrier"
        case toy_manchester_terrier = "Toy Manchester Terrier"
        case transylvanian_hound = "Transylvanian Hound"
        case treeing_cur = "Treeing Cur"
        case treeing_feist = "Treeing Feist"
        case treeing_tennessee_brindle = "Treeing Tennessee Brindle"
        case treeing_walker_coonhound = "Treeing Walker Coonhound"
        case trigg_hound = "Trigg Hound"
        case tyrolean_hound = "Tyrolean Hound"
        case vikhan = "Vikhan"
        case villano_de_las_encartaciones = "Villano de Las Encartaciones"
        case villanuco_de_las_encartaciones = "Villanuco de Las Encartaciones"
        case vizsla = "Vizsla"
        case volpino_italiano = "Volpino Italiano"
        case weimaraner = "Weimaraner"
        case welsh_sheepdog = "Welsh Sheepdog"
        case welsh_springer_spaniel = "Welsh Springer Spaniel"
        case welsh_terrier = "Welsh Terrier"
        case west_country_harrier = "West Country Harrier"
        case west_highland_white_terrier = "West Highland White Terrier"
        case west_siberian_laika = "West Siberian Laika"
        case westphalian_dachsbracke = "Westphalian Dachsbracke"
        case wetterhoun = "Wetterhoun"
        case whippet = "Whippet"
        case white_shepherd = "White Shepherd"
        case white_swiss_shepherd_dog = "White Swiss Shepherd Dog"
        case wire_fox_terrier = "Wire Fox Terrier"
        case wirehaired_pointing_griffon = "Wirehaired Pointing Griffon"
        case wirehaired_vizsla = "Wirehaired Vizsla"
        case xiasi_dog = "Xiasi Dog"
        case xoloitzcuintle = "Xoloitzcuintle"
        case yakutian_laika = "Yakutian Laika"
        case yorkshire_terrier = "Yorkshire Terrier"
        case zerdava = "Zerdava"
    }
    
}
