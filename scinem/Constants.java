package athenarc.imsi.sdl.config;

/**
 * Application constants.
 */
public final class Constants {

    // Regex for acceptable logins
    public static final String LOGIN_REGEX = "^[_.@A-Za-z0-9-]*$";
    
    public static final String SYSTEM_ACCOUNT = "system";
    public static final String DEFAULT_LANGUAGE = "en";
    public static final String ANONYMOUS_USER = "anonymoususer";
    
    public static final String BASE_PATH = "/data/SciNeM/SciNeM-results";
		public static final String HDFS_BASE_PATH = "hdfs://namenode:9000/data/SciNeM/SciNeM-results";

    public static final String HIN_OUT = "HIN";
    public static final String JOIN_HIN_OUT = "JOIN_HIN";

    public static final String SIM_JOIN_OUT = "SIM_JOIN.csv";
    public static final String SIM_SEARCH_OUT = "SIM_SEARCH.csv";
    public static final String RANKING_OUT = "RANKING";
    public static final String COMMUNITY_DETECTION_OUT = "COMMUNITIES";
    public static final String COMMUNITY_DETAILS = "COMMUNITY_DETAILS.json";

    public static final String RANKING_COMMUNITY_OUT = "RANKING_COMMUNITY_RESULT.csv";
    public static final String COMMUNITY_RANKING_OUT = "COMMUNITY_RANKING_RESULT.csv";

    public static final String FINAL_RANKING_OUT = "RANKING_RESULT.csv";
    public static final String FINAL_COMMUNITY_OUT = "COMMUNITY_RESULT.csv";
    public static final String FINAL_SIM_JOIN_OUT = "SIM_JOIN_RESULT.csv";
    public static final String FINAL_SIM_SEARCH_OUT = "SIM_SEARCH_RESULT.csv";

    public static final String CONFIG_FILE = "config.json";

    public static final String DATA_DIR = "/data/SciNeM/SciNeM-data/";
		public static final String HDFS_DATA_DIR = "hdfs://namenode:9000/data/SciNeM/SciNeM-data/";
    public static final String WORKFLOW_DIR = "/data/SciNeM/SciNeM-workflows/";
    public static final int MAX_THREADS = 10;

    public static final int PAGE_SIZE = 50;

    private Constants() {
    }
}
