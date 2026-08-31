// lib/data/traditions_repository.dart
import '../models/tradition.dart';

class TraditionsRepository {
  static const List<TraditionItem> _traditions = [
    // --- CLASSICAL DANCES ---
    TraditionItem(
      id: 'bharatanatyam',
      title: 'Bharatanatyam (The Celestial Dance)',
      hindiTitle: 'भरतनाट्यम्',
      originState: 'Tamil Nadu',
      eraOrPeriod: '2nd Century BCE (Natya Shastra)',
      category: TraditionCategory.classicalDance,
      tag: 'CLASSICAL DANCE',
      unescoStatus: 'UNESCO Recognized Intangible Heritage Tradition',
      shortDescription: 'The oldest classical dance tradition of India, blending Bhava (expression), Raga (melody), and Tala (rhythm).',
      fullChronicle: 'Originating in the sanctum sanctorums of ancient Tamil temples through the Devadasi tradition, Bharatanatyam is codified in the sage Bharata Muni\'s ancient treatise "Natya Shastra". It features crisp geometric body lines, dynamic stamping footwork (Adavus), intricate hand gestures (Mudras), and profound emotional storytelling (Abhinaya) narrating sacred epics like the Ramayana and Mahabharata.',
      keyFeatures: [
        'Aramandi: The iconic half-sitting posture forming a sacred diamond geometry',
        '64 Single-Hand & Combined Mudras (Hastha Viniyoga) conveying celestial tales',
        'Traditional Kanchipuram silk pleats that flare out during rhythmic pirouettes',
        'Melodic accompaniment with Carnatic vocalists, Mridangam, and Natuvangam cymbals'
      ],
      culturalSignificance: 'Embodies the cosmic dance of Shiva (Nataraja) and visualizes the supreme union of human devotion with divine consciousness.',
      imageUrl: 'https://images.unsplash.com/photo-1598387993441-a364f854c3e1?w=800&q=80',
    ),
    TraditionItem(
      id: 'kathakali',
      title: 'Kathakali (Story-Play of Gods & Demons)',
      hindiTitle: 'कथकळि',
      originState: 'Kerala',
      eraOrPeriod: '17th Century CE (Kottarakkara Thampuran)',
      category: TraditionCategory.classicalDance,
      tag: 'CLASSICAL DANCE',
      unescoStatus: 'UNESCO Inscribed World Living Art Form',
      shortDescription: 'Grand spectacle of dance-drama renowned for elaborate facial makeup, towering headdresses, and vivid eye choreography.',
      fullChronicle: 'Kathakali is a classical dance-drama born along the lush palm groves and royal courts of Kerala. Traditionally performed through the entire night by temple oil lamps (Vilakku), it synthesizes Sanskrit theatrical traditions with indigenous martial arts (Kalaripayattu). Characters are categorized by their inner virtues through color-coded makeup: Paccha (green for noble heroes/gods), Kathi (green with red mustache for valiant villains), and Minukku (soft amber for sages and women).',
      keyFeatures: [
        'Vesham: Intricate 4-hour facial makeup created using organic rice paste and natural minerals',
        'Kireedam: Massive, intricately carved wooden headdresses inlaid with peacock feathers',
        'Navarasas: Masterful control of 9 facial expressions executed purely via facial muscles and eye movements',
        'Thunderous live percussion using Chenda and Maddalam drums creating dramatic tension'
      ],
      culturalSignificance: 'Depicts the cosmic struggle between Dharma (righteousness) and Adharma (chaos), bringing ancient epics to life with mesmerizing visual power.',
      imageUrl: 'https://images.unsplash.com/photo-1583089892943-e02e5b017b6a?w=800&q=80',
    ),
    TraditionItem(
      id: 'odissi',
      title: 'Odissi (Sculpture in Motion)',
      hindiTitle: 'ओड़िसी',
      originState: 'Odisha',
      eraOrPeriod: '1st Century BCE (Udayagiri Caves)',
      category: TraditionCategory.classicalDance,
      tag: 'CLASSICAL DANCE',
      unescoStatus: 'Living Classical Art Tradition',
      shortDescription: 'Fluid lyrical dance style replicating the sensuous temple sculptures of Konark and Puri Jagannath.',
      fullChronicle: 'Codified in ancient temple friezes and caves of Kharavela, Odissi is characterized by its signature "Tribhangi" — a three-bend serpentine posture of neck, torso, and knee that mirrors classic temple sculptures. Accompanied by Odissi classical music, Mardala percussion, and flute, it captures the divine poetry of Jayadeva\'s "Gita Govinda".',
      keyFeatures: [
        'Tribhangi & Chowka: Sculptural postures embodying feminine grace and masculine strength',
        'Tahiya crown crafted by traditional silver filigree (Tarakasi) artisans of Cuttack',
        'Sambalpuri and Bomkai silk sarees draped in traditional kachha style',
        'Intricate torso isolations (Bhangi) creating wave-like continuous fluid motion'
      ],
      culturalSignificance: 'Originally offered as Mahari seva to Lord Jagannath, converting stone temple carvings into living devotional prayers.',
      imageUrl: 'https://images.unsplash.com/photo-1601055283742-8b27e81b5553?w=800&q=80',
    ),
    TraditionItem(
      id: 'kathak',
      title: 'Kathak (The Art of Storytelling)',
      hindiTitle: 'कथक',
      originState: 'Uttar Pradesh',
      eraOrPeriod: '4th Century BCE (Vedic Kathakars)',
      category: TraditionCategory.classicalDance,
      tag: 'CLASSICAL DANCE',
      unescoStatus: 'Indo-Gangetic Living Heritage',
      shortDescription: 'Dazzling rhythmic footwork, rapid pirouettes (Chakkars), and subtle narrative mime born in temple courtyards and Mughal royal courts.',
      fullChronicle: 'The word Kathak derives from the Sanskrit "Katha" (story). Ancient wandering bards known as Kathakars used dance, song, and mime to dramatize epics. During the medieval Mughal era, Kathak evolved in the royal courts of Lucknow and Jaipur, developing breathtaking technical virtuosity, lightning-fast spins (Chakkars), and micro-expressive glances (Nazaakat).',
      keyFeatures: [
        'Tatkar: Complex mathematical footwork tapping up to 200 bells (Ghungroos) per foot',
        'Chakkars: Rapid, seamless spins executed with pin-point balance and sudden freeze stops',
        'Gharanas: Distinct stylistic lineages (Lucknow, Jaipur, and Banaras)',
        'Harmonious blend of Hindu temple devotion and Mughal royal court sophistication'
      ],
      culturalSignificance: 'A living testament to India\'s civilizational syncretism, combining classical Sanskrit aesthetics with refined royal grace.',
      imageUrl: 'https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80',
    ),

    // --- ANCIENT MARTIAL ARTS ---
    TraditionItem(
      id: 'kalaripayattu',
      title: 'Kalaripayattu (Mother of All Martial Arts)',
      hindiTitle: 'कळरिप्पयट्ट्',
      originState: 'Kerala',
      eraOrPeriod: '3rd Century BCE (Sage Parashurama Tradition)',
      category: TraditionCategory.martialArt,
      tag: 'MARTIAL ART',
      unescoStatus: 'Oldest Surviving Martial Art in the World',
      shortDescription: 'Ancient battlefield discipline combining animal-inspired postures, flexible swordplay (Urumi), and Marma point healing.',
      fullChronicle: 'Kalaripayattu was formulated in the sacred training arenas (Kalaris) of Kerala. It incorporates the striking dynamics and defense stances of eight formidable animals (Lion, Elephant, Tiger, Horse, Boar, Snake, Peacock, and Buffalo). Practiced inside sunken mud pits dedicated to Mother Kali, it seamlessly integrates combat mastery with Ayurvedic Marma medicine (107 vital energy points of the human body).',
      keyFeatures: [
        'Meythari: Body conditioning and extreme flexibility drills with oil massages',
        'Kolthari & Angathari: Mastery of wooden staffs, daggers, spears, and curved shields',
        'Urumi: The legendary double-edged flexible whip-sword requiring master agility',
        'Marma Vidya: Deep esoteric knowledge of pressure points for incapacitation or instant healing'
      ],
      culturalSignificance: 'Considered the ancestor of Shaolin Kung Fu, spread to East Asia by the Buddhist monk Bodhidharma in the 5th century CE.',
      imageUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&q=80',
    ),
    TraditionItem(
      id: 'silambam',
      title: 'Silambam (Ancient Tamil Staff Combat)',
      hindiTitle: 'सिलम्बम',
      originState: 'Tamil Nadu',
      eraOrPeriod: '4th Century BCE (Sangam Literature)',
      category: TraditionCategory.martialArt,
      tag: 'MARTIAL ART',
      unescoStatus: 'Recognized Indian Traditional Combat Sport',
      shortDescription: 'Lightning-fast spinning staff combat developed by ancient Pandya, Chola, and Chera warrior clans.',
      fullChronicle: 'Mentioned extensively in the ancient Tamil Sangam epic "Silappadikaram", Silambam is centered around a treated bamboo staff (Pirambu) measured precisely to the practitioner\'s eyebrow height. Warriors spin the staff at blinding speed to create an impenetrable defensive dome against multiple armed attackers, incorporating footwork patterns inspired by snake and eagle movements.',
      keyFeatures: [
        'Kaaladi: Strategic footwork grids (Chathuram, Vattam) maintaining dynamic equilibrium',
        'Maduvu (Deer-horn blades) and Surul Vaal (flexible blades) integrated into advanced forms',
        'Bamboo staff heat-treated in medicinal herbal oils for unmatched tensile strength',
        'Combat system used by King Veerapandiya Kattabomman against colonial forces'
      ],
      culturalSignificance: 'Preserved by traditional village Akharas as both a martial art and a spiritual discipline of inner focus and breath control.',
      imageUrl: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&q=80',
    ),

    // --- ANCIENT SCIENCES & METALLURGY ---
    TraditionItem(
      id: 'rustless-iron-pillar',
      title: 'Gupta Metallurgical Genius: Rustless Iron Pillar',
      hindiTitle: 'गुप्त लौह स्तंभ (धातु विज्ञान)',
      originState: 'Delhi / Madhya Pradesh (Udayagiri)',
      eraOrPeriod: '4th Century CE (King Chandragupta II Vikramaditya)',
      category: TraditionCategory.ancientScience,
      tag: 'ANCIENT SCIENCE',
      unescoStatus: 'Global Metallurgical Wonder',
      shortDescription: 'A 6-tonne forged iron pillar standing for 1,600+ years in open monsoon rains without rusting.',
      fullChronicle: 'Standing at 7.21 meters tall within the Qutub complex, this monolithic pillar was forged during the Gupta Golden Age. Modern IIT metallurgists discovered that ancient Indian metallurgists used high phosphorus content with low sulfur and manganese, creating a protective "Misawite" passive surface film that repairs itself and shields the iron from corrosive atmospheric oxidation.',
      keyFeatures: [
        'Forged using ancient forge-welding techniques combining hundreds of iron blooms',
        'Passive protective layer (δ-FeOOH) that regenerates upon exposure to humidity',
        'Original Sanskrit Brahmi inscription dedicating the pillar as a Garuda Dhvaja to Lord Vishnu',
        'Proves India had advanced metallurgical furnace technology centuries ahead of Europe'
      ],
      culturalSignificance: 'Direct evidence of India\'s ancient prowess in chemistry, materials science, and advanced engineering.',
      imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&q=80',
    ),
    TraditionItem(
      id: 'stepwells-baolis',
      title: 'Baolis: Sacred Hydro-Engineering of Ancient Stepwells',
      hindiTitle: 'बावड़ी (जल संरक्षण विज्ञान)',
      originState: 'Gujarat & Rajasthan (Rani ki Vav, Chand Baori)',
      eraOrPeriod: '7th–11th Century CE (Solanki & Chahamana Dynasties)',
      category: TraditionCategory.ancientScience,
      tag: 'ANCIENT SCIENCE',
      unescoStatus: 'UNESCO World Heritage Hydro-Architecture',
      shortDescription: 'Multi-storey subterranean water sanctuaries engineered for microclimate cooling, rainwater harvesting, and community gathering.',
      fullChronicle: 'In the arid deserts of Western India, ancient architects inverted traditional temple architecture to build stepwells (Baolis/Vavs) extending up to 7 storeys underground. Sites like Rani ki Vav (Patan) and Chand Baori (Abhaneri) feature over 3,500 symmetrical stone steps arranged in mesmerizing optical patterns, harvesting seasonal monsoons and keeping underground chambers 5–8°C cooler than the surface.',
      keyFeatures: [
        'Geothermal natural cooling through subterranean structural thermal mass',
        'Complex percolation and silt filtration through porous sandstone aquifers',
        'Intricate pillared pavilions with over 800 sculptures of Vishnu’s Dashavatara',
        'Served as spiritual sanctorums, public shelters, and sustainable municipal water reserves'
      ],
      culturalSignificance: 'A magnificent manifestation of sacred ecology — venerating water as divine while solving desert droughts through sophisticated hydrology.',
      imageUrl: 'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?w=800&q=80',
    ),

    // --- VEDIC CHANTS & SACRED SHLOKAS ---
    TraditionItem(
      id: 'shanti-mantra',
      title: 'Maha Shanti Mantra (Universal Cosmic Peace)',
      hindiTitle: 'शान्ति मन्त्र (बृहदारण्यक उपनिषद्)',
      originState: 'Pan-India (Vedic Sage Yajnavalkya)',
      eraOrPeriod: '1500 BCE (Brihadaranyaka Upanishad)',
      category: TraditionCategory.vedicChant,
      tag: 'VEDIC CHANT',
      unescoStatus: 'UNESCO Intangible Cultural Heritage of Humanity',
      shortDescription: 'The supreme Vedic prayer seeking universal peace across all cosmos, elements, and consciousness.',
      fullChronicle: 'Chanted in precise mathematical Sanskrit meter (Chhandas), Vedic chanting has been transmitted orally across thousands of generations without changing a single vowel or tone accent (Svara). The UNESCO declaration of Vedic chanting as a Masterpiece of Oral Heritage acknowledges this as the world’s most ancient unbroken oral memory system.',
      keyFeatures: [
        'Svara: Strict three-tone pitch system (Udatta, Anudatta, Svarita)',
        'Oral recitation memory techniques (Pada-patha, Krama-patha, Ghana-patha)',
        'Resonates acoustic brain frequencies inducing deep meditative tranquility',
        'Unites the individual consciousness (Atman) with cosmic harmony (Brahman)'
      ],
      culturalSignificance: 'The philosophical bedrock of Indian civilizational ethics: "Vasudhaiva Kutumbakam" (The World is One Family).',
      imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&q=80',
      sanskritShloka: 'ॐ द्यौः शान्तिरन्तरिक्षं शान्तिः\nपृथिवी शान्तिरापः शान्तिरोषधयः शान्तिः ।\nवनस्पतयः शान्तिर्विश्वेदेवाः शान्तिर्ब्रह्म शान्तिः\nसर्वं शान्तिः शान्तिरेव शान्तिः सा मा शान्तिरेधि ॥\nॐ शान्तिः शान्तिः शान्तिः ॥',
      shlokaMeaning: 'May peace radiate in the celestial realm and in sky and atmosphere. May peace reign upon the earth, in the waters, in the medicinal herbs, and in the grand forest trees. May peace abide in all divine cosmic beings, in Brahman, and in all creation. May peace alone prevail, and may that supreme peace enter into my heart. Om Peace, Peace, Peace.',
      audioChantTranscript: 'Chanted in traditional Vedic pitch (Rigvedic meter) with resonant acoustic bells.',
    ),
    TraditionItem(
      id: 'gayatri-mantra',
      title: 'Gayatri Mantra (Invocation of Divine Illumination)',
      hindiTitle: 'गायत्री मन्त्र (ऋग्वेद)',
      originState: 'Pan-India (Sage Vishwamitra)',
      eraOrPeriod: 'Rigveda Mandala 3.62.10 (c. 1500 BCE)',
      category: TraditionCategory.vedicChant,
      tag: 'VEDIC CHANT',
      unescoStatus: 'Sacred World Heritage Text',
      shortDescription: 'The mother of all Vedic mantras, invoking the radiant solar deity Savitur to awaken inner intellect and wisdom.',
      fullChronicle: 'Composed in the 24-syllable Gayatri meter (Tri-pada of 8 syllables each), this sacred mantra was revealed to Sage Vishwamitra. It is traditionally chanted at the sandhyas (dawn, noon, and dusk). Modern acoustic studies have observed that its cyclic phonetics generate soothing harmonic alpha waves in the human brain.',
      keyFeatures: [
        '24 sacred syllables corresponding to 24 cosmic energy centers (Chakras)',
        'Invokes the spiritual sun behind the physical sun to enlighten our thoughts',
        'Daily spiritual anchor for millions of pilgrims, yogis, and scholars worldwide',
        'Synthesizes devotion, quantum vibrations, and cosmic awareness'
      ],
      culturalSignificance: 'Universal prayer for cognitive clarity, moral righteousness, and spiritual liberation.',
      imageUrl: 'https://images.unsplash.com/photo-1545205597-3d9d02c29597?w=800&q=80',
      sanskritShloka: 'ॐ भूर्भुवः स्वः\nतत्सवितुर्वरेण्यं\nभर्गो देवस्य धीमहि\nधियो यो नः प्रचोदयात् ॥',
      shlokaMeaning: 'We meditate upon that supreme, glorious splendor of the divine Sun (Savitur), the creator of the terrestrial, celestial, and cosmic realms. May that radiant divine light illuminate and inspire our intellect and awareness.',
      audioChantTranscript: 'Chanted with sacred Shankha (conch) resonance and temple bells.',
    ),
  ];

  static List<TraditionItem> getAllTraditions() => _traditions;

  static List<TraditionItem> getByCategory(TraditionCategory category) {
    return _traditions.where((t) => t.category == category).toList();
  }

  static TraditionItem? getById(String id) {
    try {
      return _traditions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
