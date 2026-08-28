// lib/data/festival_repository.dart
import '../models/festival.dart';

class FestivalRepository {
  static final List<Festival> _festivals = [
    Festival(
      id: 'durga-puja',
      name: 'Durga Puja (Sharodotsav)',
      hindiName: 'दुर्गा पूजा (शारदोत्सव)',
      dates: '09 – 13 October 2026',
      month: 'October',
      region: 'East India',
      state: 'West Bengal, Tripura, Assam, Odisha',
      significance: 'UNESCO Intangible Cultural Heritage of Humanity celebrating the triumph of Goddess Durga over Mahishasura, signifying victory of good over evil.',
      rituals: [
        'Mahalaya: Chanting of Chandi Path at dawn welcoming the Goddess.',
        'Bodhon, Nabapatrika Snan, Sandhi Puja with 108 lotus flowers & 108 clay lamps.',
        'Dhunuchi Naach: Euphoric ritual dance with glowing earthen incense burners.',
        'Sindoor Khela & Visarjan immersion on Vijaya Dashami.',
      ],
      culinarySpecialties: ['Khichuri Bhog with Labra', 'Beguni & Chutney', 'Mishti Doi & Roshogolla', 'Sandesh', 'Kosha Mangsho'],
      image: 'https://images.unsplash.com/photo-1601058268499-e52658b8bb88?q=80&w=800&auto=format&fit=crop',
      duration: '5 Days',
      bestSpotToExperience: 'Kolkata, Krishnanagar & Chandannagar',
    ),
    Festival(
      id: 'jagaddhatri-puja',
      name: 'Jagaddhatri Puja',
      hindiName: 'जगद्धात्री पूजा',
      dates: '18 – 21 November 2026',
      month: 'November',
      region: 'East India',
      state: 'West Bengal (Krishnanagar & Chandannagar)',
      significance: 'Special devotion to Goddess Jagaddhatri (Holder of the World), celebrated with colossal four-armed clay idols and world-famous electric street illumination.',
      rituals: [
        'Saptami, Ashtami, and Navami pujas conducted over four Prahar rituals.',
        'Colossal clay idols reaching 25–30 feet crafted by Ghurni artisans.',
        'Grand street procession with kinetic decorative tube-light floats.',
      ],
      culinarySpecialties: ['Shorbhaja & Sarpuria of Krishnanagar', 'Radhaballabhi with Alur Dom', 'Chanar Jilipi'],
      image: 'https://images.unsplash.com/photo-1583089892943-e02e5ee6beec?q=80&w=800&auto=format&fit=crop',
      duration: '4 Days',
      bestSpotToExperience: 'Krishnanagar Rajbari & Chandannagar Strand',
    ),
    Festival(
      id: 'diwali-deepawali',
      name: 'Diwali & Dev Deepawali',
      hindiName: 'दीपावली एवं देव दीपावली',
      dates: '01 – 05 November 2026',
      month: 'November',
      region: 'Pan India',
      state: 'Pan India (Special focus: Varanasi & Ayodhya)',
      significance: 'The Grand Festival of Lights celebrating Lord Rama\'s return to Ayodhya, and in Varanasi on Kartik Purnima when gods descend to take a dip in the Ganga.',
      rituals: [
        'Dhanteras: Worship of Lord Dhanvantari and Goddess Lakshmi.',
        'Lighting of millions of clay diyas, rangoli designs at doorsteps.',
        'Dev Deepawali in Varanasi: All 84 ghats illuminated with over 1.2 million oil lamps.',
      ],
      culinarySpecialties: ['Kaju Katli', 'Besan Ladoo', 'Gujiya', 'Chakli', 'Malpua'],
      image: 'https://images.unsplash.com/photo-1572445271230-a78b595f9c43?q=80&w=800&auto=format&fit=crop',
      duration: '5 Days',
      bestSpotToExperience: 'Varanasi Ghats & Ayodhya Saryu Ghat',
    ),
    Festival(
      id: 'hampi-utsav',
      name: 'Hampi Utsav (Vijaya Utsav)',
      hindiName: 'हम्पी उत्सव',
      dates: '03 – 05 November 2026',
      month: 'November',
      region: 'South India',
      state: 'Karnataka',
      significance: 'Mega cultural extravaganza reviving the royal pomp and grandeur of the Vijayanagara Empire with classical music, dance, puppet shows, and fireworks against illuminated ruins.',
      rituals: [
        'Janapada Vahini folk cultural street procession with decorated elephants and horses.',
        'Grand light and sound show illuminating the Virupaksha and Vittala temples.',
        'Classical Carnatic musical performances and martial arts display.',
      ],
      culinarySpecialties: ['Bisi Bele Bath', 'Mysore Pak', 'Ragi Mudde', 'Dharwad Peda'],
      image: 'https://images.unsplash.com/photo-1620766165457-a80fe560c8e1?q=80&w=800&auto=format&fit=crop',
      duration: '3 Days',
      bestSpotToExperience: 'Hampi Monuments & Gayatri Peetha Stage',
    ),
    Festival(
      id: 'pushkar-camel-fair',
      name: 'Pushkar Camel Fair (Kartik Mela)',
      hindiName: 'पुष्कर मेला',
      dates: '19 – 27 November 2026',
      month: 'November',
      region: 'West India',
      state: 'Rajasthan',
      significance: 'One of the world\'s largest camel and livestock fairs combined with holy pilgrimage to the sacred Pushkar Lake and the rare Brahma Temple.',
      rituals: [
        'Maha Aarti at the 52 sacred ghats of Pushkar Lake on Kartik Purnima.',
        'Camel beauty contest with colorful beaded saddles and pom-poms.',
        'Rajasthani folk music, Kalbelia dance, and turban tying competitions.',
      ],
      culinarySpecialties: ['Dal Baati Churma', 'Pushkar Malpua & Rabri', 'Gatte Ki Sabzi', 'Ker Sangri'],
      image: 'https://images.unsplash.com/photo-1599661046289-e31897846e41?q=80&w=800&auto=format&fit=crop',
      duration: '9 Days',
      bestSpotToExperience: 'Pushkar Mela Ground & Brahma Temple Ghat',
    ),
    Festival(
      id: 'jagannath-ratha-yatra',
      name: 'Puri Jagannath Ratha Yatra',
      hindiName: 'जगन्नाथ रथ यात्रा, पुरी',
      dates: '16 – 24 July 2026',
      month: 'July',
      region: 'East India',
      state: 'Odisha',
      significance: 'The world-famous Chariot Festival where Lord Jagannath, Balabhadra, and Subhadra journey in massive wooden chariots to Gundicha Temple.',
      rituals: [
        'Snana Yatra bathing ceremony followed by Anasara isolation period.',
        'Chhera Pahanra: The Gajapati King sweeps the chariot platforms with a golden broom.',
        'Millions of devotees pulling the sacred ropes of the Nandighosa chariot.',
      ],
      culinarySpecialties: ['Chhena Poda', 'Mahaprasad 56 Bhoga', 'Khaja of Puri', 'Rasabali'],
      image: 'https://images.unsplash.com/photo-1598890777032-bde835ba27c2?q=80&w=800&auto=format&fit=crop',
      duration: '9 Days',
      bestSpotToExperience: 'Grand Road (Bada Danda), Puri',
    ),
  ];

  static List<Festival> getAllFestivals() => List<Festival>.from(_festivals);

  static List<Festival> getFestivalsByRegion(String region) {
    if (region == 'All') return getAllFestivals();
    return _festivals.where((f) => f.region.toLowerCase().contains(region.toLowerCase())).toList();
  }
}
