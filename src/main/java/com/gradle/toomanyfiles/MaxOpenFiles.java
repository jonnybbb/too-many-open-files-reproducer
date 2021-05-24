package com.gradle.toomanyfiles;

import com.sun.management.UnixOperatingSystemMXBean;
import java.lang.management.ManagementFactory;

public class MaxOpenFiles {
    public static void main(final String[] argv) {
        UnixOperatingSystemMXBean osMBean = (UnixOperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
        long maxFileDescriptorLimit = osMBean.getMaxFileDescriptorCount();
        System.out.println("Java Executable max files:  " + maxFileDescriptorLimit);
    }
}
