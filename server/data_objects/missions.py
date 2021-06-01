from dataclasses import dataclass
from enum import Enum, auto
from datetime import datetime


class MissionType(Enum):
    PATROL = auto(),
    GO_TO_WAYPOINT = auto(),
    GO_TO_HOME_WAYPOINT = auto(),
    TRACK = auto()


class StartReasonType(Enum):
    CLOCK = auto(),
    USER_REQUEST = auto(),
    FOUND_THIEF = auto()


class EndReasonType(Enum):
    ENDED_AS_EXPECTED = auto(),
    USER_REQUEST = auto(),
    FOUND_THIEF = auto()


@dataclass
class Mission:
    mission_type: MissionType
    sub_missions: list
    start_reason: StartReasonType
    end_reason: EndReasonType
    start_time: datetime
    end_time: datetime


@dataclass
class GoToWaypointMission(Mission):
    lat_to_go: float
    lon_to_go: float
