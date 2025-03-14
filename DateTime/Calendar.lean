/- Copyright (c) 2024 Theodora Brick.

Authors: Thea Brick
-/

import DateTime.Utils

namespace DateTime.Calendar


def Day := {n : Nat // n ≠ 0}
deriving DecidableEq

namespace Day

def toNat : Day → Nat := (·.val)
instance : OfNat Day 1  := ⟨⟨1 , by decide⟩⟩
instance : OfNat Day 28 := ⟨⟨28, by decide⟩⟩
instance : OfNat Day 29 := ⟨⟨29, by decide⟩⟩
instance : OfNat Day 30 := ⟨⟨30, by decide⟩⟩
instance : OfNat Day 31 := ⟨⟨31, by decide⟩⟩

@[simp] def Day.add : Day → Day → Day
  | ⟨d₁, h₁⟩, ⟨d₂, _h₂⟩ =>
    ⟨ d₁ + d₂
    , by intro h; simp [Nat.zero_eq_add _ _ |>.mp h.symm] at h₁
    ⟩
instance : HAdd Day Day Day := ⟨Day.add⟩
@[simp] instance : LT Day := ⟨fun d₁ d₂ => d₁.val < d₂.val⟩
@[simp] instance : LE Day := ⟨fun d₁ d₂ => d₁.val ≤ d₂.val⟩
instance : Coe Day Nat := ⟨(·.val)⟩
instance : Inhabited Day := ⟨1⟩
instance (d₁ d₂ : Day) : Decidable (d₁ < d₂) :=
  inferInstanceAs (Decidable (d₁.val < d₂.val))
instance (d₁ d₂ : Day) : Decidable (d₁ ≤ d₂) :=
  inferInstanceAs (Decidable (d₁.val ≤ d₂.val))
instance : DecidableEq Day := fun d₁ d₂ =>
  match decEq d₁.val d₂.val with
  | isTrue h  => isTrue (Subtype.eq h)
  | isFalse h => isFalse (fun h' => by simp [h'] at h)

def to_DD  (d : Day) : String := (toString d.toNat).leftpad0 2
def to_DDD (d : Day) : String := (toString d.toNat).leftpad0 3

@[inline] private def parse_Dn (len : Nat) (s : String)
    : Except String (Day × String) := do
  if s.length ≥ len then
    if let some n := (s.extract ⟨0⟩ ⟨len⟩).toNat? then
      if h : n ≠ 0 then return ⟨⟨n, h⟩, s.drop len⟩
  throw s!"Could not parse {String.mk (List.replicate len 'D')} from {s}"

def parse_DD  : String → Except String (Day × String) := parse_Dn 2
def parse_DDD : String → Except String (Day × String) := parse_Dn 3

end Day


def Year := Nat
deriving Inhabited, DecidableEq

namespace Year

def toNat : Year → Nat := cast (by unfold Year; rfl)
instance : OfNat Year n := ⟨toNat n⟩
instance : HAdd Year Nat Year := ⟨fun y₁ y₂ => y₁.toNat + y₂⟩
instance : HMod Year Nat Year := ⟨fun y n => y.toNat % n⟩
instance : LT Year := ⟨(·.toNat < ·.toNat)⟩
instance : LE Year := ⟨(·.toNat ≤ ·.toNat)⟩

def is_leap_year (y : Year) :=
  (y.toNat % 4 = 0 && y.toNat % 100 ≠ 0) || (y.toNat % 400 = 0)

def num_days (y : Year) : Nat := if y.is_leap_year then 366 else 365

theorem zero_lt_num_days : ∀ y, 0 < num_days y := by
  intro y; rw [num_days]; cases is_leap_year y <;> decide

def to_YYYY (y : Year) : String := (toString <| show Nat from y).leftpad0 4
def to_YY (y : Year) : String :=
  (toString <| (show Nat from y) % 100).leftpad0 2
instance : Repr Year := ⟨fun y _ => to_YYYY y⟩


@[inline] private def parse_Yn (len : Nat) (s : String)
    : Except String (Year × String) := do
  if s.length ≥ len then
    if let some n := (s.extract ⟨0⟩ ⟨len⟩).toNat? then return ⟨n, s.drop len⟩
  throw s!"Could not parse {String.mk (List.replicate len 'Y')} from {s}"

def parse_YYYY : String → Except String (Year × String) := parse_Yn 4
def parse_YY   : String → Except String (Year × String) := parse_Yn 2

end Year

inductive Month
| january
| february
| march
| april
| may
| june
| july
| august
| september
| october
| november
| december
deriving Inhabited, DecidableEq

namespace Month

def toNat : Month → Nat
  | .january   => 1
  | .february  => 2
  | .march     => 3
  | .april     => 4
  | .may       => 5
  | .june      => 6
  | .july      => 7
  | .august    => 8
  | .september => 9
  | .october   => 10
  | .november  => 11
  | .december  => 12

instance : OfNat Month 1  := ⟨.january  ⟩
instance : OfNat Month 2  := ⟨.february ⟩
instance : OfNat Month 3  := ⟨.march    ⟩
instance : OfNat Month 4  := ⟨.april    ⟩
instance : OfNat Month 5  := ⟨.may      ⟩
instance : OfNat Month 6  := ⟨.june     ⟩
instance : OfNat Month 7  := ⟨.july     ⟩
instance : OfNat Month 8  := ⟨.august   ⟩
instance : OfNat Month 9  := ⟨.september⟩
instance : OfNat Month 10 := ⟨.october  ⟩
instance : OfNat Month 11 := ⟨.november ⟩
instance : OfNat Month 12 := ⟨.december ⟩
instance : LT Month := ⟨(·.toNat < ·.toNat)⟩
instance : LE Month := ⟨(·.toNat ≤ ·.toNat)⟩
instance (m₁ m₂ : Month) : Decidable (m₁ < m₂) :=
  inferInstanceAs (Decidable (m₁.toNat < m₂.toNat))
instance (m₁ m₂ : Month) : Decidable (m₁ ≤ m₂) :=
  inferInstanceAs (Decidable (m₁.toNat ≤ m₂.toNat))


def ofNat? : Nat → Option Month
  | 1  => some january
  | 2  => some february
  | 3  => some march
  | 4  => some april
  | 5  => some may
  | 6  => some june
  | 7  => some july
  | 8  => some august
  | 9  => some september
  | 10 => some october
  | 11 => some november
  | 12 => some december
  | _  => none

def ofNat! (n : Nat) : Month :=
  match ofNat? n with
  | some m => m
  | none   => default

/- Number of days in a month, assuming it is not a leap year -/
@[inline] def common_num_days : Month → Day
  | .january   => 31
  | .february  => 28
  | .march     => 31
  | .april     => 30
  | .may       => 31
  | .june      => 30
  | .july      => 31
  | .august    => 31
  | .september => 30
  | .october   => 31
  | .november  => 30
  | .december  => 31

/- The number of days in a month in a given year -/
def num_days (y : Year) : Month → Day
  | .february => if y.is_leap_year then 29 else 28
  | m => m.common_num_days

/- The next corresponding month and year -/
def next (year : Year) : Month → Month × Year
  | .january   => (.february , year)
  | .february  => (.march    , year)
  | .march     => (.april    , year)
  | .april     => (.may      , year)
  | .may       => (.june     , year)
  | .june      => (.july     , year)
  | .july      => (.august   , year)
  | .august    => (.september, year)
  | .september => (.october  , year)
  | .october   => (.november , year)
  | .november  => (.december , year)
  | .december  => (.january  , year + 1)


def to_MM (m : Month) : String := (toString m.toNat).leftpad0 2


def parse_MM (s : String) : Except String (Month × String) := do
  if s.length ≥ 2 then
    if let some n := (s.extract ⟨0⟩ ⟨2⟩).toNat? then
      if let some m := Month.ofNat? n then return ⟨m, s.drop 2⟩
  throw s!"Could not parse MM from {s}"


/- Todo: Add more language formats -- also should there be 3 letter abbrevs? -/
def to_eng : Month → String
  | .january   => "January"
  | .february  => "February"
  | .march     => "March"
  | .april     => "April"
  | .may       => "May"
  | .june      => "June"
  | .july      => "July"
  | .august    => "August"
  | .september => "September"
  | .october   => "October"
  | .november  => "November"
  | .december  => "December"
instance : Repr Month := ⟨fun m _ => m.to_eng⟩

def to_eng_abbrev : Month → String
  | .january   => "Jan."
  | .february  => "Feb."
  | .march     => "Mar."
  | .april     => "Apr."
  | .may       => "May"
  | .june      => "June"
  | .july      => "July"
  | .august    => "Aug."
  | .september => "Sept."
  | .october   => "Oct."
  | .november  => "Nov."
  | .december  => "Dec."


def to_fr : Month → String
  | .january   => "janvier"
  | .february  => "février"
  | .march     => "mars"
  | .april     => "avril"
  | .may       => "mai"
  | .june      => "juin"
  | .july      => "juillet"
  | .august    => "août"
  | .september => "septembre"
  | .october   => "octobre"
  | .november  => "novembre"
  | .december  => "décembre"

def to_fr_abbrev : Month → String
  | .january   => "janv."
  | .february  => "févr."
  | .march     => "mars"
  | .april     => "avril"
  | .may       => "mai"
  | .june      => "juin"
  | .july      => "juil."
  | .august    => "août"
  | .september => "sept."
  | .october   => "oct."
  | .november  => "nov."
  | .december  => "déc."

end Month


inductive WeekDay
| monday
| tuesday
| wednesday
| thursday
| friday
| saturday
| sunday
deriving Inhabited, DecidableEq

namespace WeekDay

def to_eng : WeekDay → String
  | .monday    => "Monday"
  | .tuesday   => "Tuesday"
  | .wednesday => "Wednesday"
  | .thursday  => "Thursday"
  | .friday    => "Friday"
  | .saturday  => "Saturday"
  | .sunday    => "Sunday"
instance : Repr WeekDay := ⟨fun wd _ => wd.to_eng⟩

def to_eng_abbrev : WeekDay → String
  | .monday    => "Mon"
  | .tuesday   => "Tue"
  | .wednesday => "Wed"
  | .thursday  => "Thu"
  | .friday    => "Fri"
  | .saturday  => "Sat"
  | .sunday    => "Sun"

def to_eng_letter : WeekDay → String
  | .monday    => "M"
  | .tuesday   => "T"
  | .wednesday => "W"
  | .thursday  => "R"
  | .friday    => "F"
  | .saturday  => "S"
  | .sunday    => "U"


def to_fr : WeekDay → String
  | .monday    => "lundi"
  | .tuesday   => "mardi"
  | .wednesday => "mercredi"
  | .thursday  => "jeudi"
  | .friday    => "vendredi"
  | .saturday  => "samedi"
  | .sunday    => "dimanche"

def to_fr_abbrev : WeekDay → String
  | .monday    => "lun."
  | .tuesday   => "mar."
  | .wednesday => "mer."
  | .thursday  => "jeu."
  | .friday    => "ven."
  | .saturday  => "sam."
  | .sunday    => "dim."

end WeekDay


inductive Date
| century        : Year → Date
| year           : Year → Date
| year_month     : Year → Month → Date
| year_month_day
  : (y : Year) → (m : Month) → (d : Day) → d ≤ m.num_days y → Date
| year_day
  : (y : Year) → (d : Day) → d.val ≤ y.num_days → Date
deriving Inhabited, DecidableEq

namespace Date

def aux_ymd (y : Year) (m : Month) (days : Nat) (nonzero : days ≠ 0) : Date :=
  let max_days := m.num_days y
  if h : days > max_days.val then -- used in the `decreasing_by`
    let (mon', year') := m.next y
    aux_ymd year' mon' (days - max_days.val)
      (Nat.ne_zero_of_lt (Nat.zero_lt_sub_of_lt h))
  else .year_month_day y m ⟨days, nonzero⟩
    (by simp [Nat.not_lt_eq _ _] at h; exact h)
termination_by days
decreasing_by
  exact Nat.sub_lt
    (Nat.zero_lt_of_ne_zero nonzero)
    (Nat.zero_lt_of_ne_zero (Month.num_days y m).property)

def aux_yd (y : Year) (days : Nat) (nonzero : days ≠ 0) : Date :=
  let max_days := y.num_days
  if h : days > max_days then -- used in the `decreasing_by`
    aux_yd (y + 1) (days - max_days)
      (Nat.ne_zero_of_lt (Nat.zero_lt_sub_of_lt h))
  else .year_day y ⟨days, nonzero⟩
    (by simp [Nat.not_lt_eq _ _] at h; exact h)
termination_by days
decreasing_by
  exact Nat.sub_lt
    (Nat.zero_lt_of_ne_zero nonzero)
    (Year.zero_lt_num_days y)

def add_ymd (date : Date) (year mon day : Nat) : Date :=
  match date with
  | .century y              => .century ((y.toNat + year) % 100)
  | .year y                 => .year (y.toNat + year)
  | .year_month y m         =>
    let m' := Month.ofNat! <| ((m.toNat - 1 + mon) % 12) + 1
    let y' := y.toNat + ((m.toNat - 1 + mon) / 12) + year
    .year_month y' m'
  | .year_month_day y m d _ =>
    let m' := Month.ofNat! <| ((m.toNat - 1 + mon) % 12) + 1
    let y' := y.toNat + ((m.toNat - 1 + mon) / 12) + year
    aux_ymd y' m' (d.val + day)
      (by have := d.property
          intro h
          simp [Nat.zero_eq_add _ _ |>.mp h.symm] at this
      )
  | .year_day y d _         =>
    aux_yd (y.toNat + year) (d.val + day)
      (by have := d.property
          intro h
          simp [Nat.zero_eq_add _ _ |>.mp h.symm] at this
      )

instance : HAdd Date (Nat × Nat × Nat) Date :=
  ⟨fun date (y, m, d) => date.add_ymd y m d⟩


def basic_format : Date → String
  | .century y              => y.to_YY
  | .year y                 => y.to_YYYY
  | .year_month y m         => s!"{y.to_YYYY}-{m.to_MM}"
  | .year_month_day y m d _ => s!"{y.to_YYYY}{m.to_MM}{d.to_DD}"
  | .year_day y d _         => s!"{y.to_YYYY}{d.to_DDD}"

/- Returns the basic format if the extend format doesn't exist -/
def extended_format : Date → String
  | .century y              => y.to_YY
  | .year y                 => y.to_YYYY
  | .year_month y m         => s!"{y.to_YYYY}-{m.to_MM}"
  | .year_month_day y m d _ => s!"{y.to_YYYY}-{m.to_MM}-{d.to_DD}"
  | .year_day y d _         => s!"{y.to_YYYY}-{d.to_DDD}"
instance : Repr Date := ⟨fun date _ => date.extended_format⟩


def parse_basic_format (str : String) : Except String Date := do
  let s := str
  try
    let (c, s) ← Year.parse_YY s
    if s = "" then return .century c
    throw "Could not parse century"
  catch _ =>
    let (y, s) ← Year.parse_YYYY s
    if s = "" then return .year y
    if s.startsWith "-" then
      let (m, s') ← Month.parse_MM (s.drop 1)
      if s' = "" then return .year_month y m
      throw s!"Tried to parse YYYY-MM from {str} but failed"
    try
      let (d, s) ← Day.parse_DDD s
      if p : d.val ≤ y.num_days then
        if s = "" then return .year_day y d p
      throw s!"Could not parse year/day from {str}"
    catch _ =>
      let (m, s) ← Month.parse_MM s
      let (d, s) ← Day.parse_DD s
      if p : d.val ≤ (m.num_days y).val then
        if s = "" then return .year_month_day y m d p
      throw s!"Failed to parse date from {str}!"

def parse_extended_format (str : String) : Except String Date := do
  let s := str

  let (y, s) ← Year.parse_YYYY s
  if ¬s.startsWith "-" then throw s!"Missing '-' after year in {str}"
  let s := s.drop 1

  try
    let (d, s) ← Day.parse_DDD s
    if p : d.val ≤ y.num_days then
      if s = "" then return .year_day y d p
    throw s!"Could not parse year/day from {str}"
  catch _ =>
    let (m, s) ← Month.parse_MM s
    if ¬s.startsWith "-" then throw s!"Missing '-' after month in {str}"
    let s := s.drop 1

    let (d, s) ← Day.parse_DD s
    if p : d.val ≤ (m.num_days y).val then
      if s = "" then return .year_month_day y m d p
    throw s!"Failed to parse date from {str}!"

def parse (str : String) : Except String Date := do
  try Date.parse_basic_format str
  catch _ =>
    try Date.parse_extended_format str
    catch _ => throw s!"Could not parse date from {str}"
