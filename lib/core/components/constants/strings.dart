import 'package:online_counsellor/generated/assets.dart';

const String emailReg =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const regionList = [
  'Greater Accra',
  'Ashanti Region',
  'Western Region',
  'Eastern Region',
  'Central Region',
  'Volta Region',
  'Northern Region',
  'Upper East',
  'Upper West',
  'Bono Region',
  'Bono East',
  'Ahafo Region',
  'Oti Region',
  'Savannah Region',
  'North East',
];

const counsellorTypeList = [
  'psychologist',
  'Marriage Counsellor',
  'Students\' Counsellor',
  'Career Counsellor',
  'Family Counsellor',
  'Addiction Counsellor',
  'Mental Health Counsellor',
  'Grief Counsellor',
  'Rehabilitation Counsellor',
  'Guidance Counsellor',
  'Child Counsellor',
];

const List<Map<String, dynamic>> reviews = [
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  }
];

final counsellorTypeWithIcon = [
  {"name": 'psychologist', "icon": Assets.images.psychologist.path},
  {"name": 'Marriage Counsellor', "icon": Assets.images.marriage.path},
  {"name": 'Students\' Counsellor', "icon": Assets.images.student.path},
  {"name": 'Career Counsellor', "icon": Assets.images.career.path},
  {"name": 'Family Counsellor', "icon": Assets.images.family.path},
  {"name": 'Addiction Counsellor', "icon": Assets.images.addiction.path},
  {"name": 'Mental Health Counsellor', "icon": Assets.images.mentalHealth.path},
  {"name": 'Grief Counsellor', "icon": Assets.images.grief.path},
  {"name": 'Rehabilitation Counsellor', "icon": Assets.images.rehabilitation.path},
  {"name": 'Guidance Counsellor', "icon": Assets.images.guidance.path},
  {"name": 'Child Counsellor', "icon": Assets.images.child.path},
];

const counsellingTopicCategory = [
  'Marriage',
  'Relationship',
  'Family',
  'Career',
  'Addiction',
  'Mental Health',
  'Grief',
  'Rehabilitation',
  'Guidance',
  'Child',
];
