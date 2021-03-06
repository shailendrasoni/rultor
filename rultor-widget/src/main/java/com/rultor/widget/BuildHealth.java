/**
 * Copyright (c) 2009-2013, rultor.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met: 1) Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer. 2) Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 * with the distribution. 3) Neither the name of the rultor.com nor
 * the names of its contributors may be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package com.rultor.widget;

import com.google.common.collect.Iterables;
import com.jcabi.aspects.Immutable;
import com.jcabi.aspects.Loggable;
import com.jcabi.aspects.Tv;
import com.rultor.spi.Coordinates;
import com.rultor.spi.Pulse;
import com.rultor.spi.Stand;
import com.rultor.spi.Tag;
import com.rultor.spi.Widget;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentSkipListMap;
import lombok.EqualsAndHashCode;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.math3.stat.StatUtils;
import org.xembly.Directives;

/**
 * Build health reporter.
 *
 * @author Yegor Bugayenko (yegor@tpc2.com)
 * @version $Id$
 * @since 1.0
 * @checkstyle MultipleStringLiterals (500 lines)
 */
@Immutable
@EqualsAndHashCode
@Loggable(Loggable.DEBUG)
@Widget.Stylesheet("build-health.xsl")
public final class BuildHealth implements Widget {

    /**
     * {@inheritDoc}
     *
     * @todo #201 If we increase the amount of elements to be
     *  processes, an OutOfMemory exception will be thrown. I don't understand
     *  why and how memory leakage is happening...
     *  http://stackoverflow.com/questions/18684598
     */
    @Override
    public Directives render(final Stand stand) {
        Directives dirs = new Directives()
            .add("width").set("4").up()
            .add("builds");
        final Collection<BuildHealth.Build> builds = this.builds(
            Iterables.limit(
                stand.pulses().query().withTag("on-commit").fetch(),
                Tv.HUNDRED
            ).iterator()
        );
        for (BuildHealth.Build build : builds) {
            dirs = dirs.append(build.directives()).up();
        }
        return dirs;
    }

    /**
     * Find all builds.
     * @param pulses Iterator of pulses
     * @return Collection of builds
     */
    @SuppressWarnings("PMD.AvoidInstantiatingObjectsInLoops")
    private Collection<BuildHealth.Build> builds(final Iterator<Pulse> pulses) {
        final ConcurrentMap<String, BuildHealth.Build> builds =
            new ConcurrentSkipListMap<String, BuildHealth.Build>();
        while (pulses.hasNext()) {
            final Pulse pulse = pulses.next();
            final String coord = String.format(
                "%s %s", pulse.coordinates().owner(), pulse.coordinates().rule()
            );
            builds.putIfAbsent(coord, new BuildHealth.Build());
            builds.get(coord).append(pulse);
        }
        return builds.values();
    }

    /**
     * Mutable single build.
     */
    @EqualsAndHashCode
    @Loggable(Loggable.DEBUG)
    private static final class Build {
        /**
         * Coordinates.
         */
        private transient Coordinates coords;
        /**
         * Tag seen last.
         */
        private transient Tag tag;
        /**
         * All codes, in reverse-chronological order.
         */
        private final transient List<Double> codes = new LinkedList<Double>();
        /**
         * Append new pulse to it.
         * @param pulse Pulse seen
         */
        public void append(final Pulse pulse) {
            final Tag etag = pulse.tags().get("on-commit");
            if (this.coords == null) {
                this.coords = pulse.coordinates();
                this.tag = etag;
            }
            if ("0".equals(etag.attributes().get("code"))) {
                this.codes.add(1d);
            } else {
                this.codes.add(0d);
            }
        }
        /**
         * Get its directives.
         * @return Directives
         */
        public Directives directives() {
            final Directives dirs = new Directives();
            if (this.coords != null) {
                dirs.add("build")
                    .add("coordinates")
                    .add("rule").set(this.coords.rule()).up()
                    .add("owner").set(this.coords.owner().toString()).up()
                    .add("scheduled").set(this.coords.scheduled().toString())
                    .up().up()
                    .add(this.tag.attributes())
                    .add("health").set(Double.toString(this.health())).up();
            }
            return dirs;
        }
        /**
         * Calculate its health.
         * @return Health
         */
        private double health() {
            final double health;
            if (this.codes.isEmpty()) {
                // @checkstyle MagicNumber (1 line)
                health = 0.5d;
            } else {
                health = StatUtils.mean(
                    ArrayUtils.toPrimitive(
                        this.codes.toArray(new Double[this.codes.size()])
                    )
                );
            }
            return health;
        }
    }

}
