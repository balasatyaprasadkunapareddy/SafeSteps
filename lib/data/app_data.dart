import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../models/safety_sign.dart';
import '../utils/app_theme.dart';

// ─── Lesson Module Data ────────────────────────────────────────────────────

class LessonModule {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final List<LessonRule> rules;

  const LessonModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.rules,
  });
}

class LessonRule {
  final String heading;
  final String body;
  final IconData icon;

  const LessonRule({
    required this.heading,
    required this.body,
    required this.icon,
  });
}

// ─── Badge Data ────────────────────────────────────────────────────────────

class BadgeInfo {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final String unlockCondition;

  const BadgeInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.unlockCondition,
  });
}

// ─── Survey Insight ────────────────────────────────────────────────────────

class SurveyInsight {
  final String stat;
  final String message;
  final String category;

  const SurveyInsight({
    required this.stat,
    required this.message,
    required this.category,
  });
}

// ═══════════════════════════════════════════════════════════════════════════
//  STATIC APPLICATION DATA
// ═══════════════════════════════════════════════════════════════════════════

class AppData {
  AppData._();

  // ── Quiz Questions ─────────────────────────────────────────────────────

  static const List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      id: 'q1',
      category: 'Traffic Signals',
      question: 'What does a RED traffic signal mean in India?',
      options: [
        'Slow down and proceed with caution',
        'Stop completely and wait',
        'Honk and continue moving',
        'Speed up to clear the junction',
      ],
      correctAnswerIndex: 1,
      explanation:
          'A red signal means STOP. You must stop before the stop line and wait until the signal turns green before proceeding.',
    ),
    QuizQuestion(
      id: 'q2',
      category: 'Pedestrian Safety',
      question: 'At a Zebra Crossing, who has the right of way?',
      options: [
        'Vehicles at all times',
        'Pedestrians at all times',
        'Whoever arrives first',
        'Two-wheelers only',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Pedestrians always have the right of way at a Zebra Crossing. All vehicles must stop and allow pedestrians to cross safely.',
    ),
    QuizQuestion(
      id: 'q3',
      category: 'Two-Wheeler Safety',
      question:
          'Under the Motor Vehicles Act in India, wearing a helmet is compulsory for:',
      options: [
        'Only the rider/driver',
        'Only if riding above 40 km/h',
        'Both rider and pillion passenger',
        'Only on national highways',
      ],
      correctAnswerIndex: 2,
      explanation:
          'The Motor Vehicles (Amendment) Act 2019 makes it compulsory for both the rider and the pillion passenger to wear an ISI-certified helmet at all times.',
    ),
    QuizQuestion(
      id: 'q4',
      category: 'Car Safety',
      question: 'Who is required by law to wear a seatbelt in a car in India?',
      options: [
        'Only the driver',
        'Driver and front-seat passenger only',
        'All occupants, including rear-seat passengers',
        'Only children under 12 years',
      ],
      correctAnswerIndex: 2,
      explanation:
          'As per the Motor Vehicles Act, seatbelts are mandatory for all occupants of a car — front AND rear seats. Violating this attracts a fine.',
    ),
    QuizQuestion(
      id: 'q5',
      category: 'Mobile Phones',
      question:
          'What does the law say about using a mobile phone while driving or riding in India?',
      options: [
        'Allowed if using a hands-free device',
        'Allowed if stopped at a red light',
        'Completely prohibited while driving or riding',
        'Allowed only for calls, not texting',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Using a mobile phone in any manner while driving, including hands-free, is illegal and dangerous. It takes your attention off the road and can cause serious accidents.',
    ),
    QuizQuestion(
      id: 'q6',
      category: 'Pedestrian Safety',
      question:
          'If there is NO footpath available, where should a pedestrian walk?',
      options: [
        'On the left side of the road, with traffic',
        'In the centre of the road',
        'On the right side of the road, facing oncoming traffic',
        'On either side, depending on traffic',
      ],
      correctAnswerIndex: 2,
      explanation:
          'When no footpath is available, walk on the RIGHT side of the road facing oncoming traffic. This allows you to see approaching vehicles and take evasive action if needed.',
    ),
    QuizQuestion(
      id: 'q7',
      category: 'Traffic Signs',
      question: 'What does an OCTAGONAL (8-sided) red sign with "STOP" mean?',
      options: [
        'Slow down and yield to traffic',
        'Stop completely; proceed only when safe',
        'Give way to vehicles on the right',
        'No vehicle entry at any time',
      ],
      correctAnswerIndex: 1,
      explanation:
          'The STOP sign (octagonal red with white text) means you must come to a complete stop at the line and proceed only when it is completely safe to do so.',
    ),
    QuizQuestion(
      id: 'q8',
      category: 'Traffic Signals',
      question: 'A FLASHING AMBER signal at an intersection means:',
      options: [
        'Stop and wait for green',
        'Continue at full speed',
        'Proceed with extreme caution',
        'Turn around immediately',
      ],
      correctAnswerIndex: 2,
      explanation:
          'A flashing amber light means slow down and proceed with caution, checking that the intersection is clear before you cross.',
    ),
    QuizQuestion(
      id: 'q9',
      category: 'Cyclist Safety',
      question: 'What is the correct hand signal for a cyclist turning RIGHT?',
      options: [
        'Extend the left arm straight out horizontally',
        'Extend the right arm straight out horizontally',
        'Move the left arm up and down',
        'Place the right hand on top of the head',
      ],
      correctAnswerIndex: 1,
      explanation:
          'To signal a right turn on a bicycle, extend your right arm straight out to the right. This gives clear warning to vehicles behind you.',
    ),
    QuizQuestion(
      id: 'q10',
      category: 'General Rules',
      question:
          'What is the MINIMUM legal age to drive a car (non-transport) in India?',
      options: ['16 years', '17 years', '18 years', '21 years'],
      correctAnswerIndex: 2,
      explanation:
          'You must be at least 18 years old to apply for a permanent driving licence for a non-transport vehicle (car/two-wheeler) in India.',
    ),
    QuizQuestion(
      id: 'q11',
      category: 'Emergency',
      question: 'When an emergency vehicle (ambulance/fire engine) approaches with its siren on, you must:',
      options: [
        'Speed up to stay ahead of it',
        'Honk back to alert other drivers',
        'Pull over to the left and let it pass',
        'Slow down but continue in your lane',
      ],
      correctAnswerIndex: 2,
      explanation:
          'You must immediately pull over to the left side and stop, giving a clear passage for the emergency vehicle. Obstructing an emergency vehicle is a serious traffic offence.',
    ),
    QuizQuestion(
      id: 'q12',
      category: 'Two-Wheeler Safety',
      question: 'Triple riding (3 persons on a two-wheeler) in India is:',
      options: [
        'Allowed if helmets are worn',
        'Allowed on state highways',
        'Legal only for children under 12',
        'Illegal and punishable by fine',
      ],
      correctAnswerIndex: 3,
      explanation:
          'Triple riding on a two-wheeler is completely illegal in India. Only two people — the rider and one pillion — are permitted, and both must wear helmets.',
    ),
    QuizQuestion(
      id: 'q13',
      category: 'Traffic Signs',
      question: 'A circular sign with a BLUE background and white symbol is a:',
      options: [
        'Warning sign (cautionary)',
        'Prohibitory sign (mandatory restriction)',
        'Mandatory direction/action sign',
        'Informatory sign',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Blue circular signs are MANDATORY signs that instruct you to do something (e.g., keep left, turn left, go straight). You MUST follow these instructions.',
    ),
    QuizQuestion(
      id: 'q14',
      category: 'Pedestrian Safety',
      question:
          'When crossing the road, what is the correct order to check for vehicles?',
      options: [
        'Left, Right, then Left again',
        'Right, Left, then Right again',
        'Only check whichever side is busier',
        'It does not matter — just run quickly',
      ],
      correctAnswerIndex: 1,
      explanation:
          'In India, traffic drives on the LEFT, so when crossing, look RIGHT first (the direction of approaching traffic in your lane), then LEFT, and RIGHT again before crossing safely.',
    ),
    QuizQuestion(
      id: 'q15',
      category: 'General Rules',
      question: 'What should you do BEFORE overtaking another vehicle?',
      options: [
        'Sound your horn repeatedly to warn them',
        'Check mirrors, signal, check blind spots, then overtake from the right',
        'Overtake quickly from the left to be safe',
        'Flash your headlights and overtake immediately',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Before overtaking, always check your mirrors, signal your intention, check blind spots, and then overtake from the RIGHT side. Never overtake from the left unless the vehicle ahead is turning right.',
    ),
  ];

  // ── Safety Signs ───────────────────────────────────────────────────────

  static const List<SafetySign> safetySigns = [
    // Mandatory Signs
    SafetySign(
      id: 's1',
      name: 'Stop',
      description: 'Come to a complete halt',
      detail:
          'You must bring your vehicle to a complete stop at the stop line. Proceed only when it is completely safe to do so and you have checked for oncoming traffic.',
      category: SignCategory.mandatory,
      icon: Icons.stop_circle_outlined,
    ),
    SafetySign(
      id: 's2',
      name: 'No Entry',
      description: 'Entry prohibited for all vehicles',
      detail:
          'No vehicle is permitted to enter the road or area beyond this sign. This is commonly used on one-way roads to prevent traffic from going the wrong way.',
      category: SignCategory.mandatory,
      icon: Icons.do_not_disturb_on_outlined,
    ),
    SafetySign(
      id: 's3',
      name: 'No Parking',
      description: 'Parking is not permitted',
      detail:
          'You may not park your vehicle at this location. Violation can result in your vehicle being towed and/or a fine. Look for the nearest designated parking area.',
      category: SignCategory.mandatory,
      icon: Icons.local_parking,
    ),
    SafetySign(
      id: 's4',
      name: 'Speed Limit 50',
      description: 'Maximum speed: 50 km/h',
      detail:
          'The maximum speed allowed on this stretch of road is 50 km/h. Exceeding this limit is illegal and dangerous. Speed limits are set based on road conditions and environment.',
      category: SignCategory.mandatory,
      icon: Icons.speed,
    ),
    SafetySign(
      id: 's5',
      name: 'Give Way',
      description: 'Yield to oncoming traffic',
      detail:
          'You must slow down and give way to vehicles on the road you are about to join. Do not enter until there is a safe gap in traffic.',
      category: SignCategory.mandatory,
      icon: Icons.merge_type,
    ),
    SafetySign(
      id: 's6',
      name: 'Compulsory Ahead',
      description: 'Proceed straight only',
      detail:
          'You must proceed straight ahead. Turning left or right at this junction is not permitted.',
      category: SignCategory.mandatory,
      icon: Icons.arrow_upward,
    ),
    // Cautionary Signs
    SafetySign(
      id: 's7',
      name: 'School Ahead',
      description: 'Drive slowly — school zone',
      detail:
          'A school or children\'s area is ahead. Slow down significantly and be prepared to stop for children crossing. Maintain low speed throughout the school zone.',
      category: SignCategory.cautionary,
      icon: Icons.school_outlined,
    ),
    SafetySign(
      id: 's8',
      name: 'Pedestrian Crossing',
      description: 'Zebra crossing ahead',
      detail:
          'A pedestrian crossing (Zebra Crossing) is ahead. Slow down and be prepared to stop. Pedestrians have the right of way at Zebra Crossings.',
      category: SignCategory.cautionary,
      icon: Icons.directions_walk,
    ),
    SafetySign(
      id: 's9',
      name: 'Sharp Curve Ahead',
      description: 'Dangerous bend approaching',
      detail:
          'A sharp curve is ahead. Reduce your speed well before the curve — do not brake while turning. Use the correct lane and watch for oncoming vehicles.',
      category: SignCategory.cautionary,
      icon: Icons.turn_right,
    ),
    SafetySign(
      id: 's10',
      name: 'Narrow Road',
      description: 'Road width reduces ahead',
      detail:
          'The road becomes narrower ahead. Slow down and move to the centre of your lane. Be cautious of oncoming traffic and give way if necessary.',
      category: SignCategory.cautionary,
      icon: Icons.compare_arrows,
    ),
    SafetySign(
      id: 's11',
      name: 'Slippery Road',
      description: 'Surface may be slippery',
      detail:
          'The road surface ahead may be slippery due to rain, oil, or loose material. Reduce speed, avoid sudden braking, and increase your following distance.',
      category: SignCategory.cautionary,
      icon: Icons.water_drop_outlined,
    ),
    SafetySign(
      id: 's12',
      name: 'Railway Crossing',
      description: 'Train tracks ahead',
      detail:
          'A railway level crossing is ahead. Stop before the crossing if a train is approaching or the barrier is lowered. Never race the train.',
      category: SignCategory.cautionary,
      icon: Icons.train_outlined,
    ),
    // Informatory Signs
    SafetySign(
      id: 's13',
      name: 'Hospital',
      description: 'Medical facility nearby',
      detail:
          'A hospital is nearby. Be especially considerate of noise — avoid honking unnecessarily. Emergency vehicles may be entering or exiting.',
      category: SignCategory.informatory,
      icon: Icons.local_hospital_outlined,
    ),
    SafetySign(
      id: 's14',
      name: 'Petrol Station',
      description: 'Fuel available ahead',
      detail:
          'A petrol/fuel station is available ahead. If your fuel level is low, this is a good opportunity to refuel. Observe all safety rules at petrol stations.',
      category: SignCategory.informatory,
      icon: Icons.local_gas_station_outlined,
    ),
    SafetySign(
      id: 's15',
      name: 'Parking Area',
      description: 'Designated parking zone',
      detail:
          'A designated parking area is available. Park only within the marked bays, observe any time restrictions, and ensure you do not block other vehicles.',
      category: SignCategory.informatory,
      icon: Icons.local_parking,
    ),
    SafetySign(
      id: 's16',
      name: 'First Aid Post',
      description: 'Emergency medical help',
      detail:
          'A first-aid post is located here. In case of an accident or medical emergency, trained personnel and basic medical equipment are available.',
      category: SignCategory.informatory,
      icon: Icons.medical_services_outlined,
    ),
    SafetySign(
      id: 's17',
      name: 'Public Telephone',
      description: 'Phone facility available',
      detail:
          'A public telephone is available nearby. This can be used in emergency situations to contact help or report an accident.',
      category: SignCategory.informatory,
      icon: Icons.phone_outlined,
    ),
  ];

  // ── Lesson Modules ─────────────────────────────────────────────────────

  static final List<LessonModule> lessonModules = [
    LessonModule(
      id: 'mod1',
      title: 'Pedestrian Safety',
      subtitle: 'Walking rules for roads & crossings',
      emoji: '🚶',
      color: AppTheme.pedestrianColor,
      rules: const [
        LessonRule(
          heading: 'Use the Footpath',
          body:
              'Always walk on the footpath or pavement. If there is no footpath, walk on the extreme right side of the road facing oncoming traffic so you can see approaching vehicles.',
          icon: Icons.directions_walk,
        ),
        LessonRule(
          heading: 'Always Use Zebra Crossings',
          body:
              'Cross roads only at designated Zebra Crossings, subways, or pedestrian bridges. Never cross between parked vehicles or at sharp bends where drivers cannot see you.',
          icon: Icons.swap_horiz,
        ),
        LessonRule(
          heading: 'Look Right, Left, Right',
          body:
              'In India, traffic drives on the LEFT side. Before crossing, look RIGHT first, then LEFT, and then RIGHT again. Cross only when there is a safe gap in traffic.',
          icon: Icons.visibility,
        ),
        LessonRule(
          heading: 'Obey Pedestrian Signals',
          body:
              'At signalised crossings, wait for the green "Walk" signal. Do not start crossing on a flashing green — it means the signal is about to change.',
          icon: Icons.traffic,
        ),
        LessonRule(
          heading: 'No Phone While Walking',
          body:
              'Avoid using your mobile phone, listening to music with earphones, or any activity that distracts you while walking on or crossing the road.',
          icon: Icons.phone_disabled,
        ),
        LessonRule(
          heading: 'Night-time Visibility',
          body:
              'Wear reflective clothing or carry a torch when walking at night. This helps drivers see you from a distance and react in time.',
          icon: Icons.nights_stay_outlined,
        ),
      ],
    ),
    LessonModule(
      id: 'mod2',
      title: 'Cyclist Safety',
      subtitle: 'Safe cycling habits for roads',
      emoji: '🚴',
      color: AppTheme.cyclistColor,
      rules: const [
        LessonRule(
          heading: 'Always Wear a Helmet',
          body:
              'A properly fitted helmet is your most important piece of safety equipment. It significantly reduces the risk of serious head injury in a crash.',
          icon: Icons.sports_motorsports,
        ),
        LessonRule(
          heading: 'Ride on the Left Edge',
          body:
              'In India, cyclists must ride on the left side of the road, close to the kerb. Never ride in the middle of the road unless overtaking a stationary vehicle.',
          icon: Icons.directions_bike,
        ),
        LessonRule(
          heading: 'Use Hand Signals',
          body:
              'Signal your turns: extend your RIGHT arm for right turns, LEFT arm for left turns, and move your hand up and down to indicate slowing down or stopping.',
          icon: Icons.back_hand_outlined,
        ),
        LessonRule(
          heading: 'Use Lights at Night',
          body:
              'Equip your bicycle with a white headlight at the front and a red reflector or light at the rear when riding at night or in poor visibility.',
          icon: Icons.flashlight_on_outlined,
        ),
        LessonRule(
          heading: 'No Earphones While Riding',
          body:
              'Never use earphones while cycling. You need to hear horns, engine sounds, and other audio cues from vehicles around you to stay safe.',
          icon: Icons.headset_off,
        ),
        LessonRule(
          heading: 'Stay in Single File',
          body:
              'When riding in a group, always ride in single file (one behind the other), not side by side. This keeps the road clear for other vehicles.',
          icon: Icons.linear_scale,
        ),
      ],
    ),
    LessonModule(
      id: 'mod3',
      title: 'Two-Wheeler Safety',
      subtitle: 'Motorbike & scooter road rules',
      emoji: '🏍️',
      color: AppTheme.twoWheelerColor,
      rules: const [
        LessonRule(
          heading: 'Helmet is Mandatory by Law',
          body:
              'Both the rider and the pillion passenger are legally required to wear an ISI-certified helmet under the Motor Vehicles Act. An unfastened helmet offers no protection.',
          icon: Icons.sports_motorsports,
        ),
        LessonRule(
          heading: 'Minimum Age & Valid Licence',
          body:
              'You must be at least 18 years old and have a valid driving licence. Riding without a licence can result in vehicle seizure and a heavy fine.',
          icon: Icons.badge_outlined,
        ),
        LessonRule(
          heading: 'No Phone While Riding',
          body:
              'Using a mobile phone while riding is illegal and one of the leading causes of accidents among young people. If you must use a phone, pull over safely first.',
          icon: Icons.phone_disabled,
        ),
        LessonRule(
          heading: 'No Triple Riding',
          body:
              'Only two people — the rider and one pillion — are permitted on a two-wheeler. Triple riding destabilises the vehicle and is illegal in India.',
          icon: Icons.group_off,
        ),
        LessonRule(
          heading: 'Lane Discipline',
          body:
              'Avoid weaving between lanes. Keep to a lane and signal clearly before changing lanes. Sudden lane changes cause accidents, especially at high speeds.',
          icon: Icons.alt_route,
        ),
        LessonRule(
          heading: 'Check Speed at Turns',
          body:
              'Always slow down well before turning or entering a curve. Leaning into a turn at high speed can cause the rider to lose control, especially on uneven roads.',
          icon: Icons.speed,
        ),
      ],
    ),
    LessonModule(
      id: 'mod4',
      title: 'Car & Bus Safety',
      subtitle: 'Safety rules for four-wheelers & buses',
      emoji: '🚗',
      color: AppTheme.carColor,
      rules: const [
        LessonRule(
          heading: 'Seatbelt for Everyone',
          body:
              'All passengers — front and back — must wear seatbelts. In a collision, an unbelted rear passenger can become a projectile that seriously injures front passengers.',
          icon: Icons.airline_seat_recline_normal,
        ),
        LessonRule(
          heading: 'Do Not Distract the Driver',
          body:
              'Keep noise levels low and avoid activities that distract the driver. A distracted driver takes 5 seconds to react — at 60 km/h, that\'s 83 metres of blind travel.',
          icon: Icons.do_not_disturb,
        ),
        LessonRule(
          heading: 'Exit on the Kerb Side',
          body:
              'Always exit a car on the footpath side (left), away from moving traffic. Before opening the door, check your mirror for approaching cyclists and vehicles.',
          icon: Icons.door_back_door_outlined,
        ),
        LessonRule(
          heading: 'Bus Safety Rules',
          body:
              'Wait behind the safety line at bus stops. Board and alight only when the bus has fully stopped. Never try to board or exit a moving bus.',
          icon: Icons.directions_bus,
        ),
        LessonRule(
          heading: 'Child Safety',
          body:
              'Children under 4 years must be secured in an approved child safety seat. Children should sit in the rear seat and must wear seatbelts at all times.',
          icon: Icons.child_care,
        ),
        LessonRule(
          heading: 'Observe Speed Limits',
          body:
              'Speed limits in India: Urban areas — 50 km/h; Residential/school zones — 25–30 km/h; Expressways — up to 120 km/h. Always follow posted limits.',
          icon: Icons.speed,
        ),
      ],
    ),
  ];

  // ── Badges ─────────────────────────────────────────────────────────────

  static const List<BadgeInfo> badges = [
    BadgeInfo(
      id: 'b1',
      title: 'First Step',
      description: 'Welcome to SafeSteps! You\'ve started your road safety journey.',
      emoji: '🏁',
      color: Color(0xFF6366F1),
      unlockCondition: 'Open the app for the first time',
    ),
    BadgeInfo(
      id: 'b2',
      title: 'Knowledge Seeker',
      description: 'You completed your first learning module.',
      emoji: '📖',
      color: Color(0xFF2563EB),
      unlockCondition: 'Complete any lesson module',
    ),
    BadgeInfo(
      id: 'b3',
      title: 'Quiz Starter',
      description: 'You completed your first quiz. Great start!',
      emoji: '❓',
      color: Color(0xFF10B981),
      unlockCondition: 'Complete first quiz',
    ),
    BadgeInfo(
      id: 'b4',
      title: 'Safety Scholar',
      description: 'Scored 70% or more on a quiz. You\'re getting sharp!',
      emoji: '🎓',
      color: Color(0xFFF59E0B),
      unlockCondition: 'Score 70%+ on any quiz',
    ),
    BadgeInfo(
      id: 'b5',
      title: 'Traffic Expert',
      description: 'Scored 90% or more. You know the roads inside out!',
      emoji: '🏆',
      color: Color(0xFFEF4444),
      unlockCondition: 'Score 90%+ on any quiz',
    ),
    BadgeInfo(
      id: 'b6',
      title: 'SafeSteps Champion',
      description: 'Completed ALL modules and scored 90%+. True champion!',
      emoji: '🌟',
      color: Color(0xFF8B5CF6),
      unlockCondition: 'Complete all 4 modules and score 90%+ on quiz',
    ),
  ];

  // ── Local Survey Insights ──────────────────────────────────────────────

  static const List<SurveyInsight> surveyInsights = [
    SurveyInsight(
      stat: '68%',
      message:
          'of students surveyed at local schools didn\'t know bicycle reflector rules.',
      category: 'Cyclist Safety',
    ),
    SurveyInsight(
      stat: '74%',
      message:
          'of teens admitted to using their phone while crossing the road at least once.',
      category: 'Pedestrian Safety',
    ),
    SurveyInsight(
      stat: '52%',
      message:
          'of students said they don\'t always wear helmets when riding as a pillion passenger.',
      category: 'Two-Wheeler Safety',
    ),
    SurveyInsight(
      stat: '81%',
      message:
          'didn\'t know that rear-seat seatbelts are legally mandatory in India.',
      category: 'Car Safety',
    ),
  ];

  // ── Leaderboard Local Fallback ─────────────────────────────────────────

  static const List<Map<String, dynamic>> localLeaderboard = [
    {'name': 'Aarav S.', 'score': 95, 'level': 5},
    {'name': 'Priya M.', 'score': 90, 'level': 4},
    {'name': 'Rohit K.', 'score': 85, 'level': 4},
    {'name': 'Sneha R.', 'score': 80, 'level': 3},
    {'name': 'Dev T.', 'score': 75, 'level': 3},
  ];
}
