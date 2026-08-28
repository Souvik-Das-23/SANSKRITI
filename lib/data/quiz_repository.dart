// lib/data/quiz_repository.dart
import '../models/quiz_question.dart';

class QuizRepository {
  static final List<QuizQuestion> questions = [
    QuizQuestion(
      question: 'Which Indian monument\'s stone chariot is featured on the reverse side of the Indian ₹50 currency note?',
      options: ['Konark Sun Temple', 'Vittala Temple, Hampi', 'Mahabalipuram Shore Temple', 'Khajuraho Temple'],
      correctIndex: 1,
      explanation: 'The iconic Stone Chariot (Garuda Shrine) located inside the Vittala Temple complex in Hampi, Karnataka is featured on the ₹50 banknote.',
      heritageFact: 'Hampi was the grand capital of the medieval Vijayanagara Empire and is a UNESCO World Heritage Site.',
    ),
    QuizQuestion(
      question: 'The 1,600-year-old rust-resistant Iron Pillar located in Delhi belongs to which ancient Indian era?',
      options: ['Mauryan Empire', 'Gupta Empire (Chandragupta II)', 'Chola Dynasty', 'Mughal Empire'],
      correctIndex: 1,
      explanation: 'The Iron Pillar carries a Brahmi inscription mentioning King Chandra, identified as Emperor Chandragupta II Vikramaditya of the Gupta Golden Age.',
      heritageFact: 'Its high phosphorus content and formation of a protective crystalline iron hydrogen phosphate layer prevent oxidation.',
    ),
    QuizQuestion(
      question: 'Which 18th-century Bengal ruler patronized the famous clay doll artisans of Ghurni and celebrated court poet Bharatchandra Ray?',
      options: ['Nawab Siraj-ud-Daulah', 'Maharaja Krishna Chandra Ray', 'Rani Rashmoni', 'Mir Jafar'],
      correctIndex: 1,
      explanation: 'Maharaja Krishna Chandra Ray of Nadia (Krishnanagar) transformed the region into an epicenter of arts, literature, and clay sculptures in the 18th century.',
      heritageFact: 'He is also renowned for the popular folk tales of his quick-witted courtier Gopal Bhar.',
    ),
    QuizQuestion(
      question: 'Kailash Temple at Ellora (Cave 16) is uniquely famous in world architecture because:',
      options: [
        'It is made entirely of white Makrana marble',
        'It was carved from top-to-bottom from a single monolithic basalt rock cliff',
        'It was built without using any stone',
        'It is submerged under a river lake'
      ],
      correctIndex: 1,
      explanation: 'Rashtrakuta sculptors excavated an estimated 200,000 tonnes of basalt rock vertically from top to bottom to create the multi-storey monolithic temple without any joints.',
      heritageFact: 'It remains the largest monolithic rock excavation on Earth.',
    ),
    QuizQuestion(
      question: 'Which sacred city on the banks of the Ganges has 84 historic stone ghats and is considered one of the oldest continuously inhabited cities?',
      options: ['Haridwar', 'Rishikesh', 'Varanasi (Kashi)', 'Prayagraj'],
      correctIndex: 2,
      explanation: 'Varanasi (also known as Kashi and Benares) has been a continuous spiritual, philosophical, and musical center of India for over 3,000 years.',
      heritageFact: 'Mark Twain noted that Varanasi is older than history and tradition.',
    ),
  ];
}
